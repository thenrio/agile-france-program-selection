require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'invoice/invoicer'
require 'connector/xero'
require 'model/company'

connector = Connector::Xero.new($xero_consumer_key, $xero_secret_key, $xero_options)

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

