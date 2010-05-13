require 'dm-core'
require 'model/full_named'

class Company
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'registration_company'

  property :id, Serial, :field => 'company_id'
  property :name, String
  property :firstname, String
  property :lastname, String
  property :email, String
  property :invoicing_system_id, String

  has n, :invoices
  has n, :attendees

  def invoiceables
    return @invoiceables if @invoiceables
    @invoiceables = []
    attendees.each do |attendee|
      @invoiceables.concat attendee.invoiceables
    end
    @invoiceables
  end

  def declared_in_invoicing_system?
    not invoicing_system_id.nil?
  end

  def create_invoice
    invoice = Invoice.new(:company => self, :date => Date.today)
    self.invoiceables.each do |invoiceable|
      invoice.invoiceables.push invoiceable
    end
    invoice
  end
end