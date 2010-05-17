require File.expand_path(File.dirname(__FILE__) + '/../config/boot')

# and what about some rake task ?
# will look better...

require 'mailer'
Mailer.new.mail_communicate_refusal