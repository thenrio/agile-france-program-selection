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

  has n, :invoices
  has n, :attendees
end

class Attendee
  include DataMapper::Resource
#  include FullNamed
  storage_names[:default] = 'registration_attendee'

  property :id, Serial, :field => 'attendee_id'
  property :firstname, String
  property :lastname, String
  property :email, String
  property :early, Boolean
  property :lunch, Boolean
  property :invited_by, String

  belongs_to :company

  def invoiceables
    invoices = []
    place = Invoiceable.new
    place = Invoiceable.new('AGF10P220') if early?
    place = Invoiceable.new('AGF10P0') if invited?
    invoices.push place
    diner = Invoiceable.new('AGF10D40') if diner?
    invoices.push diner if diner
    invoices
  end

  alias_method :diner=, :lunch=
  alias_method :diner?, :lunch?

  def invited?
    invited_by != nil
  end
end

class Invoice
  include DataMapper::Resource

  property :id, Serial
  property :xero_id, String

  belongs_to :company
  has n, :invoice_items
end

class InvoiceItem
  include DataMapper::Resource

  property :id, Serial
  property :xero_item_id, String

  belongs_to :invoice
  belongs_to :attendee
end