require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'

module Connector
  class Xero < Base
    def initialize(consumer, secret, options)
    end

    def put_invoice(company, invoiceables)
    end

    def create_invoice(company, invoiceables)
    end
  end
end