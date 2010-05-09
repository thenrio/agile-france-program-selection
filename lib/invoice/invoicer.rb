require 'invoice/invoiceable'

class Invoicer
  attr_accessor :connector

  def invoice_companies
    Company.all.each do |company|
      invoice_company company
    end
  end

  def invoice_company(company)
  
  end
end