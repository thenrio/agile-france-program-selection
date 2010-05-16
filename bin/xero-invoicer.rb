$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
require 'invoice/invoicer'
require 'connector/xero'
require 'configuration'
require 'model/company'
require 'ruby-debug'

options = {:site => 'https://api.xero.com',
           :request_token_path => "/oauth/RequestToken",
           :access_token_path  => "/oauth/AccessToken",
           :authorize_path     => "/oauth/Authorize",
           :signature_method => 'RSA-SHA1',
           :private_key_file => File.join(File.dirname(__FILE__), '../keys/xero.rsa')}
consumer_key = 'NTA0YZDJZTM0M2JHNDQ0MMJHY2NLMT'
secret_key = 'XHHWNGJGRUDMXQKVBQIZEBGG2ROFRF'
connector = Connector::Xero.new(consumer_key, secret_key, options)

$invoicer = Invoicer.new(connector)
path = File.expand_path(File.join(File.dirname(__FILE__), '../../agile-france-database/prod.db'))
Configuration.new :path => path

$invoices = []
$problems = []

def invoice()
  Company.all.each do |company|
    begin
      invoice = $invoicer.invoice_company(company)
      $invoices << invoice unless invoice.empty?
    rescue Exception => problem
      $problems << problem
      Connector::Xero.logger.error "failed to post invoice for #{company}, #{problem}"
    end
  end
end

require 'mail'
mail_options = {:address => "smtpauth.dbmail.com",
                :domain => "dbmail.com",
                :port => 25,
                :user_name => "thierry.henrio@dbmail.com",
                :password => "vhx224wub",
                :authentication => :login}

Mail.defaults do
  delivery_method :smtp, mail_options
end

def mail()
  content = Renderer::Hml.new.render('xero/report.html.haml', :problems => $problems, :invoices => $invoices)
  title = "#{$invoices.size} new invoices in draft"
  mail = Mail.new do
    content_type 'text/html; charset=UTF-8'
    from 'orga@conf.agile-france.org'
    to "thierry.henrio@gmail.com"
    subject(title)
    body(content)
  end
  mail.deliver!
end

invoice()
mail()

