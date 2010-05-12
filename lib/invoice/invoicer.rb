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
    @connector.put_contact(company).save unless company.invoicing_id
  end

  def invoice_company(company)
    create_company(company)
    invoice = Invoice.new(:company => company, :date => Date.today)
    company.invoiceables.each do |invoiceable|
      invoice.invoiceables.push invoiceable
    end
    @connector.put_invoice(invoice).save
  end
end