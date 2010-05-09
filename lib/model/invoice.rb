require 'dm-core'

class Invoice
  include DataMapper::Resource

  property :id, Serial
  property :invoice_id, String

  belongs_to :company
  has n, :invoice_items
end

class InvoiceItem
  include DataMapper::Resource

  property :id, Serial
  property :invoice_item_id, String

  belongs_to :invoice
  belongs_to :attendee
end