require 'dm-core'
require 'model/full_named'

class Attendee
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'registration_attendee'

  property :id, Serial, :field => 'attendee_id'
  property :firstname, String
  property :lastname, String
  property :email, String
  property :early, Boolean
  property :lunch, Boolean
  property :invited_by, String

  belongs_to :company, :required => false

  def invoiceables
    return @invoiceables if @invoiceables
    @invoiceables = []
    place = Invoiceable.new
    place = Invoiceable.new(:invoice_item_id => 'AGF10P220') if early?
    place = Invoiceable.new(:invoice_item_id => 'AGF10P0') if invited?
    add_invoiceable_if_not_already_invoiced(place)
    if diner?
      diner = Invoiceable.new(:invoice_item_id => 'AGF10D40')
      diner = Invoiceable.new(:invoice_item_id => 'AGF10D0') if invited?
      add_invoiceable_if_not_already_invoiced(diner)
    end
    @invoiceables
  end

  alias_method :diner=, :lunch=
  alias_method :diner?, :lunch?

  def invited?
    invited_by != nil
  end

  def add_invoiceable_if_not_already_invoiced(invoiceable)
    if invoiceable
      @invoiceables.push invoiceable unless Invoiceable.first(:attendee => self, :invoice_item_id => invoiceable.invoice_item_id)
      invoiceable.attendee = self
    end
  end
  private :add_invoiceable_if_not_already_invoiced
end