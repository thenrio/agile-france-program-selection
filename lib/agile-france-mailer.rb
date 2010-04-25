$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'mailer'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/db/prod.db'

# and what about some rake task ?
# will look better...

options = { :address => "smtpauth.dbmail.com",
            :domain => "dbmail.com",
            :port => 25,
            :user_name => "thierry.henrio@dbmail.com",
            :password => "vhx224wub",
            :authentication => :login}

Mail.defaults do
  delivery_method :smtp, options
end

Mailer.new.mail_speaker_having_at_least_one_scheduled_session

