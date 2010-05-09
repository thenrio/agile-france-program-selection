require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'builder'
require 'model/company'
require 'model/attendee'
require 'model/invoice'
require 'nokogiri'
require 'logger'

class Date
  def xero_format
    self.strftime('%Y%m%d')
  end
end

module Connector
  class Xero < Base
    attr_writer :access_token
    attr_accessor :date, :offset

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
      self.date = Date.today
      self.offset = 15
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
      invoice.invoice_id = parse_response response.body
      invoice
    end

    # parse response and return xpath content for /Response/Invoices/Invoice/InvoiceNumber
    def parse_response(response)
      case response.code
        when 200 then success!(response)
        else fail!(response)
      end
    end

    def success!(response)
      doc = Nokogiri::XML(response.body)
      doc.xpath('/Response/Invoices/Invoice/InvoiceNumber').first.content
    end

    def fail!(response)
      doc = Nokogiri::XML(response.body)
      messages = doc.xpath('//Message').to_a.map{|element| element.content}.uniq!
      raise Problem, messages.join(', ')
    end

#    def invoice(company, invoiceables)
#      invoice = parse(put_invoice(company, invoiceables))
#      invoice.save
#    end

    def create_invoice(company, invoiceables)
      builder = Builder::XmlMarkup.new
      builder.Invoice { |invoice|
        invoice.Type('ACCREC')
        invoice.Contact { |contact|
          contact.Name(company.name)
          contact.FirstName(company.firstname)
          contact.LastName(company.lastname)
          contact.EmailAddress(company.email)
        }
        invoice.Date(date.xero_format)
        invoice.DueDate((date+offset).xero_format)
        invoice.LineAmountTypes('Exclusive')
        invoice.LineItems { |items|
          invoiceables.each { |invoiceable|
            items.LineItem { |item|
              item.Description(invoiceable.code)
              item.Quantity(invoiceable.quantity)
              item.UnitAmount(invoiceable.price)
              item.AccountCode('AGFSI')
            }
          }
        }
      }
    end

    class Problem < StandardError; end
  end
end