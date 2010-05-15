require 'dm-core'
require 'forwardable'

class Invoice
  include DataMapper::Resource
  extend Forwardable


  property :id, Serial
  property :invoicing_system_id, String
  property :date, Date

  belongs_to :company
  has n, :invoiceables

  def_delegator :invoiceables, :empty?
  def_delegator :company, :email
  def_delegator :company, :has_conflicting_emails?
end