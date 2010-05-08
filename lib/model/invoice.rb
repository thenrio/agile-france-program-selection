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

  belongs_to :company

  def invoiceables
    [Invoiceable.new]
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