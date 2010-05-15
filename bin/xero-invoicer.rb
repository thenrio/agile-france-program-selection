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

@invoicer = Invoicer.new(connector)
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
invoices = []

def invoice(invoices)
  Company.all.each do |company|
    invoices << @invoicer.invoice_company(company)
  end
end

require 'mailer'
mail_options = {:address => "smtpauth.dbmail.com",
                :domain => "dbmail.com",
                :port => 25,
                :user_name => "thierry.henrio@dbmail.com",
                :password => "vhx224wub",
                :authentication => :login}

Mail.defaults do
  delivery_method :smtp, mail_options
end

def mail(invoices)
  body = Renderer::Hml.new.render('xero/report.html.haml', :invoices => invoices)
  mail = Mail.new do
    content_type 'text/html; charset=UTF-8'
    from 'orga@conf.agile-france.org'
    to "thierry.henrio@gmail.com"
    subject("#{invoices.size} new invoices in draft")
    body(body)
  end
  mail.deliver!
end

invoice(invoices)
mail(invoices)

