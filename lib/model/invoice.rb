require 'dm-core'

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