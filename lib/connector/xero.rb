require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'builder'

module Connector
  class Xero < Base
    attr_writer :access_token
    def initialize(consumer_key, secret_key, options)
      @consumer_key = consumer_key
      @secret_key = secret_key
      @options = options
    end

    def access_token
      return @access_token if @access_token
      consumer = OAuth::Consumer.new(@consumer_key, @secret_key, @options)
      @access_token = OAuth::AccessToken.new(consumer, @consumer_key, @secret_key)
    end

    def put_invoice(company, invoiceables)

    end

    def create_invoice(company, invoiceables)
      builder = Builder::XmlMarkup.new
      xml = builder.Invoice {|invoice|
        invoice.Type('ACCREC')
        }
    end
  end
end