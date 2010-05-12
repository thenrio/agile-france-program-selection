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

    def put_invoice(invoice)
      uri = 'https://api.xero.com/api.xro/2.0/Invoice'
      invoice_as_xml = create_invoice(invoice)
      logger.info "send #{invoice_as_xml}"
      response = access_token.put(uri, invoice_as_xml)
      logger.info "get #{response.code}, #{response.body}"

      invoice.invoice_id = parse_invoice_response(response)
      invoice
    end

    def put_contact(company)
      uri = 'https://api.xero.com/api.xro/2.0/Contact'
      xml = create_contact(company)
      logger.info "send #{xml}"
      response = access_token.put(uri, xml)
      logger.info "get #{response.code}, #{response.body}"

      company.invoicing_id = parse_contact_response(response)
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

    # parse response and return xpath content for /Response/Invoices/Invoice/InvoiceNumber
    def parse_invoice_response(response)
      parse_response(response) {|r| return extract_invoice_id(r)}
    end

    # parse response and return xpath content for /Response/Invoices/Invoice/InvoiceNumber
    def parse_contact_response(response)
      parse_response(response) {|r| return extract_contact_id(r)}
    end

    def extract_invoice_id(response)
      doc = Nokogiri::XML(response.body)
      doc.xpath('/Response/Invoices/Invoice/InvoiceNumber').first.content
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