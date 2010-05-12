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
    return @connector.put_contact(company).save unless company.invoicing_system_id
    company
  end

  def invoice_company(company)
    company = create_company(company)
    @connector.put_invoice(company.create_invoice).save
  end
end