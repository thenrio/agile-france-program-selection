$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'
require 'model/program'
require 'model/attendee'
require 'model/company'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

Speaker.scheduled.each do |speaker|
  attendee = Attendee.first(:lastname => speaker.email)
  if attendee
    attendee.redeemable_coupon = 'ORGANIZATION'
    attendee.save
    puts "#{attendee.inspect} gain redeemable coupon"
  end
end
