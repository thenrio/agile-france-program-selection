$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
require 'invoice/invoicer'
require 'connector/xero'
require 'configuration'
require 'model/company'


options = {:site => 'https://api.xero.com',
           :request_token_path => "/oauth/RequestToken",
           :access_token_path  => "/oauth/AccessToken",
           :authorize_path     => "/oauth/Authorize",
           :signature_method => 'RSA-SHA1',
           :private_key_file => '/Users/thenrio/src/ruby/spike-on-xero/keys/xero.rsa'}
consumer_key = 'NTA0YZDJZTM0M2JHNDQ0MMJHY2NLMT'
secret_key = 'XHHWNGJGRUDMXQKVBQIZEBGG2ROFRF'
connector = Connector::Xero.new(consumer_key, secret_key, options)
invoicer = Invoicer.new(connector)


Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
invoicer.invoice_companies