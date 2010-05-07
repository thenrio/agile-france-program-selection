require 'invoice/payment'

class Invoicer
  attr_accessor :connector

  def select_receivable_invoices
    []
  end
end