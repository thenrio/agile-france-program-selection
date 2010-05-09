require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'builder'
require 'model/company'
require 'model/attendee'
require 'model/invoice'

class Date
  def xero_format
    self.strftime('%Y%m%d')
  end
end

module Connector
  class Xero < Base
    attr_writer :access_token
    attr_accessor :date, :offset

    def initialize(consumer_key, secret_key, options)
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
      response = @access_token.put(uri, create_invoice(company, company.invoiceables))

      invoice = Invoice.new(:company => company)
      invoice.invoice_id = parse(response)

    end

    # parse response and return the Response/Invoices/Invoice/InvoiceNumber
    def parse(response)
      
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
        invoice.LineAmountType('Exclusive')
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
  end
end