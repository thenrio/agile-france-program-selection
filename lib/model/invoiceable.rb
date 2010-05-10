require 'dm-core'

class Invoiceable
  include DataMapper::Resource

  property :id, Serial
  property :invoice_item_id, String, :default => 'AGF10P270'

  belongs_to :invoice
  belongs_to :attendee

  attr_writer :price

  def price
    return @price if @price
    invoice_item_id =~ /AGF10(\D+)(\d+)/
    self.price = Integer($2) if $2
    @price
  end
end