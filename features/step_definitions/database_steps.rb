require 'spec/spec_helper'
require 'mailer'
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

And 'speaker thierry has email thierry.henrio@gmail.com' do
  Speaker.create(:firstname => 'thierry', :lastname => 'henrio', :email => 'thierry.henrio@gmail.com')
end

And 'speaker thierry has two scheduled sessions' do
  speaker = Speaker.first(:firstname => 'thierry')
  room = Room.create(:name => 'room')
  date = DateTime.now
  2.times do |time|
    Session.create(:title => "session#{time}", :speaker => speaker, :room => room, :scheduled_at => date)
  end
end

And /^company "(\w+)" has invoice "(.+)"/ do |name, invoicing_system_id|
  company = Company.first(:name => name)
  Invoice.create(:invoicing_system_id => invoicing_system_id, :company => company)
end

And /^invoice "(.+)" has an invoiceable "(.+)" for "(\w+)"/ do |invoice, invoiceable, user|
  i = Invoice.first(:invoicing_system_id => invoice)
  attendee = Attendee.first(:firstname => user)
  Invoiceable.create(:invoicing_system_id => invoiceable, :attendee => attendee, :invoice => i)
end

And 'attendee thierry has email thierry.henrio@gmail.com' do
  Attendee.create(:firstname => 'Chuck', :lastname => 'Norris', :email => 'thierry.henrio@gmail.com')
end