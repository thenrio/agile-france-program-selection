require 'dm-core'
require 'forwardable'

class Invoice
  include DataMapper::Resource
  extend Forwardable

  property :id, Serial
  property :invoicing_system_id, String
  property :date, Date
  property :settlement, Integer, :default => 10

  belongs_to :company
  has n, :invoiceables

  def_delegator :invoiceables, :empty?
  def_delegator :company, :email
  def_delegator :company, :full_name
  def_delegator :company, :has_conflicting_emails?

  def due_date
    date+settlement
  end

  def price
    # there is no inject on datamapper collection is there ?
    price = 0
    invoiceables.each {|inv| price += inv.price}
    price
  end
end