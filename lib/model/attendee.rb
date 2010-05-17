require 'dm-core'
require 'model/full_named'
require 'model/poor_boolean_support'
require 'set'

class Attendee
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'registration_attendee'

  property :id, Serial, :field => 'attendee_id'
  property :firstname, String
  property :lastname, String
  property :email, String
  property :early, Integer
  property :lunch, Integer
  property :redeemable_coupon, String

  extend PoorBooleanSupport
  quack_on_question_mark :early, :lunch

  belongs_to :company, :required => false

  def invoiceables
    return @invoiceables if @invoiceables
    @invoiceables = []
    place = Invoiceable.new
    place = Invoiceable.new(:invoicing_system_id => 'AGF10P220') if early?
    place = Invoiceable.new(:invoicing_system_id => 'AGF10P0') if entrance_redeemed?
    add_invoiceable_if_not_already_invoiced(place)
    if diner?
      diner = Invoiceable.new(:invoicing_system_id => 'AGF10D40')
      diner = Invoiceable.new(:invoicing_system_id => 'AGF10D0') if diner_redeemed?
      add_invoiceable_if_not_already_invoiced(diner)
    end
    @invoiceables
  end

  alias_method :diner=, :lunch=
  alias_method :diner?, :lunch?

  @@entrance_coupon = Set.new ['JUG', 'ORGANIZATION', 'SPEAKER', 'SPONSOR']
  def entrance_redeemed?
    @@entrance_coupon.include?(redeemable_coupon)
  end
  private :entrance_redeemed?

  @@diner_coupon = Set.new ['ORGANIZATION', 'SPEAKER', 'SPONSOR']
  def diner_redeemed?
    @@diner_coupon.include?(redeemable_coupon)
  end
  private :diner_redeemed?

  def add_invoiceable_if_not_already_invoiced(invoiceable)
    if invoiceable
      @invoiceables.push invoiceable unless Invoiceable.first(:attendee => self, :invoicing_system_id => invoiceable.invoicing_system_id)
      invoiceable.attendee = self
    end
  end
  private :add_invoiceable_if_not_already_invoiced
end