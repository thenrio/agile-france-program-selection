require 'spec/spec_helper'

Given /mail uses "(\w+)" environment/ do |env|
  load "config/#{env}/mail_configuration.rb"
end

When /^invoice "(.+)" is mailed using template "(.+)"/ do |invoice, template|
  i = Invoice.first(:invoice_system_id => invoice)
  Mailer.new.mail_invoice(i, template)
end

Then /^company should received a mail with attached file "(.+)"/ do |file|

end