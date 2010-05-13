#encoding: utf-8
require 'dm-core'

class Invoiceable
  include DataMapper::Resource

  property :id, Serial
  property :invoice_item_id, String, :default => 'AGF10P270'

  belongs_to :invoice
  belongs_to :attendee

  attr_writer :price

  @@descriptions = {'AGF10P270' => 'Place',
                    'AGF10P220' => 'Early',
                    'AGF10P0' => 'Place Gratuite',
                    'AGF10D40' => 'Diner',
                    'AGF10D0' => 'Diner Gratuit'}
  
  def price
    return @price if @price
    invoice_item_id =~ /AGF10(\D+)(\d+)/
    self.price = Integer($2) if $2
    @price
  end

  def description
    "#{invoice_item_id} - #{Invoiceable.describe(invoice_item_id)} - #{attendee.full_name}"
  end
  
  def self.describe(invoicing_system_id)
    description = @@descriptions[invoicing_system_id]
    description = '' unless description
    description
  end
end