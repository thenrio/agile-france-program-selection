require 'spec/spec_helper'

Given /mail uses "(\w+)" environment/ do |env|
  load "config/#{env}/mail_configuration.rb"
end

When /^invoice "(.+)" is mailed using template "(.+)"/ do |id, template|
  invoice = Invoice.first(:invoicing_system_id => id)
  @mail = Mailer.new.mail_invoice(invoice, template)
end

Then /^company "(.\w+)" should received a mail with attached file "(.+)"/ do |name, file|
  company = Company.first(:name => name)
  @mail.to.should == [company.email]
  @mail.attached
end