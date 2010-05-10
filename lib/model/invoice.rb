require 'dm-core'

class Invoice
  include DataMapper::Resource

  property :id, Serial
  property :invoice_id, String

  belongs_to :company
  has n, :invoiceables
end