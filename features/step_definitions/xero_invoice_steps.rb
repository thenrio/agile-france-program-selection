Given 'a XeroInvoicer using sandbox xero account' do
  require 'connector/xero'
  require 'invoice/invoicer'
  options = {:site=> 'https://api.xero.com',
              :request_token_path => "/oauth/RequestToken",
              :access_token_path  => "/oauth/AccessToken",
              :authorize_path     => "/oauth/Authorize",
              :signature_method => 'RSA-SHA1',
              :private_key_file => '/Users/thenrio/src/ruby/spike-on-xero/keys/xero.rsa'}
  consumer_key = 'NTA0YZDJZTM0M2JHNDQ0MMJHY2NLMT'
  secret_key = 'XHHWNGJGRUDMXQKVBQIZEBGG2ROFRF'
  @connector = Connector::Xero.new(consumer_key, secret_key, options)
  @invoicer = Invoicer.new
end
And 'database is empty' do
  require 'configuration'
  Configuration.new.test
end

And /database has a company "(.*)"/ do |company_name|
  @google = Company.new(:name => company_name)
  @google.save
end

When 'XeroInvoicer invoices' do
  @invoicer.invoice_companies
end

Then /there is an invoice for "(.*)" having a xero_id field/ do |company_name|
  invoice = Invoice.first(:company => @google)
  debugger
  invoice.should_not be_nil
  invoice.xero_id.should_not be_nil
end