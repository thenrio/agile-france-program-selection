require 'model/invoiceable'
require 'connector/base'
require 'date'
class Invoicer
  attr_accessor :connector
  def initialize(connector = Connector::Base.new)
    self.connector = connector
  end

  def create_company(company)
    @connector.post_contact(company).save if can_post? company
    company
  end

  def invoice_company(company)
    company = create_company(company)
    invoice = company.create_invoice
    @connector.post_invoice(invoice).save unless invoice.empty?
    invoice
  end

  def can_post?(company)
    return false if company.yet_in_invoicing_system?
    return true if company.name.nil?
    get_available_companies[company.name.downcase].nil?
  end

  def get_available_companies
    unless @companies_indexed_by_name_downcase
      @companies_indexed_by_name_downcase = {}
      @connector.get_contacts.each do |company|
        @companies_indexed_by_name_downcase[company.name.downcase] = company
      end
    end
    @companies_indexed_by_name_downcase
  end
end