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