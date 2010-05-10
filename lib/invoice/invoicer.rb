require 'invoice/invoiceable'
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

  def invoice_company(company)
    invoice_id = @connector.put_invoice(company)
    invoice = Invoice.new(:invoice_id => invoice_id, :company => company)
    company.invoiceables.each do |invoiceable|
      invoice_item = InvoiceItem.new(:invoice_item_id => invoiceable.code, :attendee => invoiceable.attendee)
      company.invoice_items.push invoice_item
    end
    invoice.save
  end
end