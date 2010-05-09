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
    @connector.put_invoice(company)
  end
end