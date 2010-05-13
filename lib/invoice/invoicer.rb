require 'model/invoiceable'
require 'connector/base'
require 'date'
class Invoicer
  attr_accessor :connector
  def initialize(connector = Connector::Base.new)
    self.connector = connector
  end

  def invoice_companies
    Company.all.each do |company|
      invoice_company company
    end
  end

  def create_company(company)
    @connector.post_contact(company).save unless company.yet_in_invoicing_system?
    company
  end

  def invoice_company(company)
    company = create_company(company)
    invoice = company.create_invoice
    @connector.post_invoice(invoice).save unless invoice.empty?
    invoice
  end
end