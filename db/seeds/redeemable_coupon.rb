$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'
require 'model/program'
require 'model/attendee'
require 'model/company'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

def redeem(attendee)
  attendee.update(:redeemable_coupon => 'ORGANIZATION')
  puts "#{attendee.inspect} gain redeemable coupon"
end

Speaker.scheduled.each do |speaker|
  attendee = Attendee.first(:email => speaker.email)
  if attendee
    redeem(attendee)
  end
end

# and there
redeem Attendee.first(:email => 'lefevre@algodeal.com')

