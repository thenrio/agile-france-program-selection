require 'connector/base'
require 'oauth'
require 'oauth/signature/rsa/sha1'
require 'model/company'
require 'model/attendee'
require 'model/invoice'
require 'nokogiri'
require 'logger'
require 'renderer'
require 'monkey-date'


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

    def send(uri, xml, verb=:put)
      logger.info "send #{xml}"
      response = access_token.request(verb, uri, xml)
      logger.info "get #{response.code}, #{response.body}"
      return response
    end

    def put_invoice(invoice)
      uri = 'https://api.xero.com/api.xro/2.0/Invoice'
      response = send(uri, create_invoice(invoice))

      parse_response(response) do |r|
        invoice.invoice_id = extract_invoice_id(r)
      end
      invoice
    end

    def put_contact(company)
      uri = 'https://api.xero.com/api.xro/2.0/Contact'
      response = send(uri, create_contact(company))

      parse_response(response) do |r|
        company.invoicing_id = extract_contact_id(r)
      end
      company
    end

    # parse response and return xpath content for /Response/Invoices/Invoice/InvoiceNumber
    def parse_response(response)
      case Integer(response.code)
        when 200 then
          return yield(response)
        else
          fail!(response)
      end
    end

    def extract_invoice_id(response)
      doc = Nokogiri::XML(response.body)
      result = doc.xpath('/Response/Invoices/Invoice/InvoiceNumber').first
      result.content if result
    end

    def extract_contact_id(response)
      doc = Nokogiri::XML(response.body)
      doc.xpath('/Response/Contacts/Contact/ContactID').first.content
    end

    def fail!(response)
      doc = Nokogiri::XML(response.body)
      messages = doc.xpath('//Message').to_a.map { |element| element.content }.uniq
      raise Problem, messages.join(', ')
    end

    def create_invoice(invoice)
      @renderer.render('xero/invoice.xml.haml', :invoice => invoice)
    end

    def create_contact(company)
      @renderer.render('xero/contact.xml.haml', :company => company)
    end

    class Problem < StandardError;
    end
  end
end