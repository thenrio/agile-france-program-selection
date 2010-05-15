require 'model/invoiceable'
require 'connector/base'
require 'date'
class Invoicer
  attr_accessor :connector

  def initialize(connector = Connector::Base.new)
    self.connector = connector
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
    lookup_available_contact(company).nil?
  end

  def create_company(company)
    merge!(company)
    company = @connector.post_contact(company) if can_post? company
    company.save
    company
  end

  def merge_contact_in_company(company, contact)
    attributes_but_mail = contact.attributes.reject do |key, value|
      key == :email
    end
    company.invoicing_system_email = contact.email
    company.attributes = company.attributes.merge(attributes_but_mail)
  end
  private :merge_contact_in_company

  def lookup_available_contact(company)
    get_available_companies[company.name.downcase]
  end

  def merge!(company)
    contact = lookup_available_contact(company)
    merge_contact_in_company(company, contact) if contact
    company
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