require 'dm-core'

class Invoice
  include DataMapper::Resource

  property :id, Serial
  property :invoicing_system_id, String
  property :date, Date

  belongs_to :company
  has n, :invoiceables
end