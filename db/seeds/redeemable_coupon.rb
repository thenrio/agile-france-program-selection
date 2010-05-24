require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'model/program'
require 'model/attendee'
require 'model/company'
require 'model/invoice'
require 'ruby-debug'

def redeem(attendee)
  attendee.update(:redeemable_coupon => 'SPEAKER')
  puts "#{attendee.inspect} gain redeemable coupon"
end

def agile_france
  @agile_france ||= Company.get(:email => 'orga@conf.agile-france.org')
  unless @agile_france
    filler = 'filler'
    attributes = {:name => 'agile-france',
              :firstname => 'agile', :lastname => 'france',
              :email => 'orga@conf.agile-france.org',
              :invoicing_system_id => 'self'}
    @agile_france = Company.create(attributes)
  end
  @agile_france
end

Speaker.scheduled.each do |speaker|
  attendee = Attendee.first(:email => speaker.email)
  if attendee
    redeem(attendee)
  else
    attributes = {:firstname => speaker.firstname, :lastname => speaker.lastname, :email => speaker.email,
                  :company => agile_france, :redeemable_coupon => 'SPEAKER', :lunch => 1}
    attendee = Attendee.create(attributes)
    puts "#{speaker.inspect} attends as #{attendee.inspect}"
  end
end

