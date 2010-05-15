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
    posted_company(company).nil?
  end

  def create_company(company)
    merge!(company)
    if can_post? company
      company = @connector.post_contact(company)
      add_posted_company(company)
    end
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

  def posted_company(company)
    posted_companies[company.name.downcase]
  end

  def merge!(company)
    contact = posted_company(company)
    merge_contact_in_company(company, contact) if contact
    company
  end

  def add_posted_company(company)
    @companies_indexed_by_name_downcase[company.name.downcase] = company
  end
  private :add_posted_company

  def posted_companies
    unless @companies_indexed_by_name_downcase
      @companies_indexed_by_name_downcase = {}
      @connector.get_contacts.each do |company|
        add_posted_company(company)
      end
    end
    @companies_indexed_by_name_downcase
  end
end