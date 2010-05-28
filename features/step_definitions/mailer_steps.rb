require 'spec/spec_helper'

Given /mail uses "(\w+)" environment/ do |env|
  load "config/#{env}/mail_configuration.rb"
end


When /^invoice "(.+)" is mailed using template "(.+)"/ do |id, template|
  invoice = Invoice.first(:invoicing_system_id => id)
  @mail = Mailer.new.mail_invoice(invoice, template)
end

When 'speaker thierry is mailed' do
  speaker = Speaker.first(:firstname=>'thierry')
  mailer = Mailer.new
  mailer.confirm_speaker(speaker)
  @deliveries = mailer.deliver!
end

Then /^company "(.\w+)" should received a mail with attached file "(.+)"/ do |name, file|
  company = Company.first(:name => name)
  @mail.to.should == [company.email]
  @mail.attached
end

Then 'thierry should receive one mail with two sessions' do
  @deliveries.size.should == 1
end

When 'attendee thierry is mailed' do
  attendee = Attendee.first(:firstname=>'thierry')
  mailer = Mailer.new
  mailer.confirm_attendee(attendee)
  @deliveries = mailer.deliver!
end

Then 'attendee thierry should receive a mail' do
  @deliveries.size.should == 1
end