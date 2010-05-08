require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'

module Connector
  class Xero < Base
    def initialize(consumer_key, secret_key, options)
      @consumer_key = consumer_key
      @secret_key = secret_key
      @options = options
    end

    def access_token
      consumer = OAuth::Consumer.new(@consumer_key, @secret_key, @options)
      @access_token = OAuth::AccessToken.new(consumer, @consumer_key, @secret_key)
      @access_token
    end

    def put_invoice(company, invoiceables)
    end

    def create_invoice(company, invoiceables)
    end
  end
end