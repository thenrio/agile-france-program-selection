require 'dm-core'
require 'model/full_named'

class Company
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'registration_company'

  property :id, Serial, :field => 'company_id'
  property :name, String
  property :firstname, String
  property :lastname, String
  property :email, String

  has n, :invoices
  has n, :attendees

  def invoiceables
    return @invoiceables if @invoiceables
    @invoiceables = []
    attendees.each do |attendee|
      @invoiceables.concat attendee.invoiceables
    end
    @invoiceables
  end
end