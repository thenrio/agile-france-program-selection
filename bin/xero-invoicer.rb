require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'invoice/invoicer'
require 'connector/xero'
require 'model/company'

$invoices = []
$problems = []

def init_invoicer
  connector = Connector::Xero.new($xero_consumer_key, $xero_secret_key, $xero_options)
  $invoicer = Invoicer.new(connector)
end

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
  title = "#{$invoices.size} new invoices in draft, and #{$problems.size} problems"
  mail = Mail.new do
    content_type 'text/html; charset=UTF-8'
    from 'orga@conf.agile-france.org'
    to "thierry.henrio@gmail.com"
    subject(title)
    body(content)
  end
  unless($invoices.empty? and $problems.empty?)
    Connector::Xero.logger.info "mailer report =>\n#{content}"
    mail.deliver!
  end
  Connector::Xero.logger.info "program terminated with #{title}"
end

init_invoicer()
invoice()
mail()

