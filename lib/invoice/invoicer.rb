require 'model/invoiceable'
require 'connector/base'
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
    company.invoicing_id = @connector.put_company(company)
    company.save
  end

  def invoice_company(company)
    create_company(company) unless company.invoicing_id
    
    invoice_id = @connector.put_invoice(company)
    invoice = Invoice.new(:invoice_id => invoice_id, :company => company)
    company.invoiceables.each do |invoiceable|
      invoice.invoiceables.push invoiceable
    end
    invoice.save
  end
end