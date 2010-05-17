require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'model/program'

# and what about some rake task ?
# will look better...

require 'mailer'
options = { :address => "smtpauth.dbmail.com",
:domain => "dbmail.com",
:port => 25,
:user_name => "thierry.henrio@dbmail.com",
:password => "vhx224wub",
:authentication => :login}

Mail.defaults do
  delivery_method :smtp, options
end
Mailer.new.mail_communicate_refusal

