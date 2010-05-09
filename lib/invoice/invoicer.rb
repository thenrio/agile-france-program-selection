require 'invoice/invoiceable'
require 'connector/base'
class Invoicer
  attr_accessor :connector
  def initialize
    self.connector = Connector::Base.new
  end

  def invoice_companies
    Company.all.each do |company|
      invoice_company company
    end
  end

  def invoice_company(company)
    @connector.put_invoice(company, [1,2])
  end
end