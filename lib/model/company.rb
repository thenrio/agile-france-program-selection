require 'dm-core'
require 'model/support/full_named'

class Company
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'registration_company'

  property :id, Serial, :field => 'company_id'
  property :name, String
  property :firstname, String
  property :lastname, String
  property :email, String
  property :size, String, :default => '10'
  property :activity, String, :default => '10'
  property :phone, String, :default => '10'
  property :address, String, :default => '10'
  property :zipcode, String, :default => '10'
  property :town, String, :default => '10'
  property :country, String, :default => '10'
  property :creation_date, Date, :default => DateTime.now
  property :modification_date, Date, :default => DateTime.now
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

  def yet_in_invoicing_system?
    not invoicing_system_id.nil?
  end

  def create_invoice
    invoice = Invoice.new(:company => self, :date => Date.today)
    self.invoiceables.each do |invoiceable|
      invoice.invoiceables.push invoiceable
    end
    invoice
  end

  attr_accessor :invoicing_system_email
  def has_conflicting_emails?
    not email == invoicing_system_email
  end
end