require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'builder'
require 'model/company'
require 'model/attendee'
require 'model/invoice'
require 'nokogiri'
require 'logger'
require 'renderer'

class Date
  def xero_format
    self.strftime('%Y-%m-%d')
  end
end

module Connector
  class Xero < Base
    attr_writer :access_token
    attr_accessor :date, :settlement

    def self.logger
      @@logger ||= Logger.new("xero-#{Date.today}.log")
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def logger
      self.class.logger
    end

    def initialize(consumer_key=nil, secret_key=nil, options={})
      @consumer_key = consumer_key
      @secret_key = secret_key
      @options = options
      @renderer = Renderer::Hml.new
      self.date = Date.today
      self.settlement = 15
    end

    def access_token
      return @access_token if @access_token
      consumer = OAuth::Consumer.new(@consumer_key, @secret_key, @options)
      @access_token = OAuth::AccessToken.new(consumer, @consumer_key, @secret_key)
    end

    def put_invoice(company)
      uri = 'https://api.xero.com/api.xro/2.0/Invoice'
      invoice_as_xml = create_invoice(company, company.invoiceables)
      logger.info "send #{invoice_as_xml}"
      response = access_token.put(uri, invoice_as_xml)
      logger.info "get #{response.code}, #{response.body}"

      invoice = Invoice.new(:company => company)
      invoice.invoice_id = parse_invoice_response(response)
      invoice
    end

    # parse response and return xpath content for /Response/Invoices/Invoice/InvoiceNumber
    def parse_invoice_response(response)
      case Integer(response.code)
        when 200 then
          extract_invoice_id(response)
        else
          fail!(response)
      end
    end

    def extract_invoice_id(response)
      doc = Nokogiri::XML(response.body)
      doc.xpath('/Response/Invoices/Invoice/InvoiceNumber').first.content
    end

    def fail!(response)
      doc = Nokogiri::XML(response.body)
      messages = doc.xpath('//Message').to_a.map { |element| element.content }.uniq
      raise Problem, messages.join(', ')
    end

    def create_invoice(company, invoiceables)
      builder = Builder::XmlMarkup.new
      builder.Invoice { |invoice|
        invoice.Type('ACCREC')
        invoice.Contact { |contact|
          contact.ContactNumber(company.id)
          contact.Name("#{company.name}")
          contact.EmailAddress(company.email)
          contact.ContactStatus('ACTIVE')
          contact.AccountsRecievableTaxType('OUTPUT')
          contact.AccountsPayableTaxType('INPUT')
          contact.FirstName(company.firstname)
          contact.LastName(company.lastname)
          contact.DefaultCurrency('EUR')
          contact.Adresses { |addresses|
            addresses.Address { |address|
              address.AddressType('POBOX')
              address.AddressLine1('PO Box 10112')
              address.City('New York')
              address.Region('New York State')
              address.PostalCode('10112')
              address.Country('USA')
            }
          }
          contact.Phones {|phones|
            phones.Phone{|phone|
              phone.PhoneType('DEFAULT')
              phone.PhoneNumber('5996999')
              phone.PhoneAreaCode('877')
              phone.PhoneCountryCode('0001')
            }
          }
        }
        invoice.Date(date.xero_format)
        invoice.DueDate((date+settlement).xero_format)
        invoice.CurrencyCode('EUR')
        invoice.LineAmountTypes('Exclusive')
#        invoice.Status('SUBMITTED')
        invoice.LineItems { |items|
          invoiceables.each { |invoiceable|
            items.LineItem { |item|
              item.Description(invoiceable.invoice_item_id)
              item.Quantity(1)
              item.UnitAmount(invoiceable.price)
              item.AccountCode('20010AGFI')
            }
          }
        }
      }
    end

    def create_contact(company)
      @renderer.render('xero/contact.xml.haml', :company => company)
    end

    class Problem < StandardError;
    end
  end
end