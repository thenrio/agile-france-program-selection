require 'spec/spec_helper'

And 'database is empty' do
  empty_database
end

And /^company "(\w+)" has email "(.+)"/ do |name, email|
  Company.create(:name => name, :email => email)
end

And /^user "(\w+)" with email "(.+)" belongs to "(.+)"/ do |firstname, email, name|
  company = Company.first(:name => name)
  Attendee.create(:firstname => firstname, :email => email, :company => company)
end

And /^company "(\w+)" has invoice "(.+)"/ do |name, invoicing_system_id|
  company = Company.first(:name => name)
  Invoice.create(:invoicing_system_id => invoicing_system_id, :company => company)
end

And /^invoice "(.+)" has an invoiceable "(.+)" for "(\w+)"/ do |invoice, invoiceable, user|
  i = Invoice.first(:invoice_system_id => invoice)
  attendee = Attendee.first(:firstname => user)
  Invoiceable.create(:invoice_system_id => invoiceable, :attendee => attendee, :invoice => i)
end

