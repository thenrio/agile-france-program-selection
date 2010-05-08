require 'invoice/invoiceable'

class Invoicer
  attr_accessor :connector

  def invoice_companies
    payments = []
    Company.all.each do |company|
      payment = invoice_company company
      payments.push payment if payment
    end
    payments
  end

  def invoice_company(company)
    return nil if company.attendees.empty?
    Invoiceable.new(:standard, 1) if company.invoices.empty?
  end
end