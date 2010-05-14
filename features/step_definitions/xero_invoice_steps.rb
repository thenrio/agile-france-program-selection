require 'spec/spec_helper'

Given 'a XeroInvoicer using sandbox xero account' do
  require 'invoice/invoicer'
  require 'connector/xero'



  options = {:site => 'https://api.xero.com',
             :request_token_path => "/oauth/RequestToken",
             :access_token_path  => "/oauth/AccessToken",
             :authorize_path     => "/oauth/Authorize",
             :signature_method => 'RSA-SHA1',
             :private_key_file => '/Users/thenrio/src/ruby/spike-on-xero/keys/xero.rsa'}
  consumer_key = 'NTA0YZDJZTM0M2JHNDQ0MMJHY2NLMT'
  secret_key = 'XHHWNGJGRUDMXQKVBQIZEBGG2ROFRF'
  @connector = Connector::Xero.new(consumer_key, secret_key, options)
  @invoicer = Invoicer.new(@connector)

end
And 'database is empty' do
  require 'configuration'
  Configuration.new.test
end

And 'database has a company 37signals' do
  @signals37 = Company.new(:name => '37signals', :firstname => 'D', :lastname => 'HH', :email => 'john@doe.com')
  @signals37.invoicing_system_id = '4CED6122-1F86-428D-8118-4030FC765BA6'
  @signals37.save
end

And 'John Doe, from 37signals, attends' do
  @john = Attendee.create(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.com', :company => @signals37)
  debugger
  @john.early?.should_not be_true
  end

And 'wycats, from 37signals, attends as early' do
  @wycats = Attendee.create(:firstname => 'wy', :lastname => 'katz', :email => 'wycats', :company => @signals37, :early => 1)
  @wycats.early?.should be_true
end

When 'XeroInvoicer invoices 37signals' do
  @invoicer.invoice_company @signals37
end

Then 'there is an invoice for 37signals having an invoicing_system_id field' do
  invoice = Invoice.first(:company => @signals37)
  invoice.should_not be_nil
  invoice.invoicing_system_id.should_not be_nil
end