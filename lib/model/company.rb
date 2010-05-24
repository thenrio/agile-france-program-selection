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
  property :size, String, :default => '1'
  property :activity, String, :default => '10'
  property :phone, String, :default => '10'
  property :address, String, :default => '10'
  property :zipcode, String, :default => '10'
  property :town, String, :default => '10'
  property :country, String, :default => '10'
  # bloody date and software convention
  # datetime is a String in sqlite3
  # it is serialized as 2010-05-24T10:47:54+02:00 by datamapper and 2010-05-23 23:58:19.368257 by django
  # datamapper can read django date, and django can not ...
  property :creation_date, String, :default => '2010-05-23 23:58:19.368257'
  property :modification_date, String, :default => '2010-05-23 23:58:19.368257'
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