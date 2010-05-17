require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'model/program'
require 'model/attendee'
require 'model/company'

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

