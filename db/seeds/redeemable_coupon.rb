require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'model/program'
require 'model/attendee'
require 'model/company'
require 'model/invoice'
require 'ruby-debug'

def redeem(attendee, coupon='SPEAKER')
  attendee.update(:redeemable_coupon => coupon)
  puts "#{attendee.inspect} gain redeemable coupon"
end

def agile_france
  @agile_france ||= Company.first(:email => 'orga@conf.agile-france.org')
  unless @agile_france
    attributes = {:name => 'agile-france',
                  :firstname => 'agile', :lastname => 'france',
                  :email => 'orga@conf.agile-france.org',
                  :invoicing_system_id => 'self'}
    @agile_france = Company.create(attributes)
  end
  @agile_france
end

def organize(first_name, last_name, email)
  organizer = Attendee.first(:email => email) ||
      Attendee.create(:firstname => first_name, :lastname => last_name, :email => email, :company => agile_france, :lunch => 1)
  organizer.update(:lunch => 1) unless organizer.diner?
  redeem(organizer, 'ORGANIZATION')
  organizer
end

#1 speaker
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

#2 jug
jugger = Attendee.first(:email => 'fabrice.bouteiller@gmail.com')
redeem(jugger, 'JUG') if jugger

#3 orga
# organize('Agata', 'Sobik', 'agata.sobik@gmail.com')
organize('Jonathan', 'Scher', 'scher.jonathan@gmail.com')
organize('Pascal', 'Pratmarty', 'pascal.pratmarty@agitude.fr')
organize('Sebastien', 'Douche', 'sdouche@gmail.com')
organize('Thibault', 'Bouchette', 'tbouchette@yahoo.fr')
organize('Thierry', 'Henrio', 'thierry.henrio@gmail.com')
organize('Yannick', 'Ameur', 'yannick.ameur@gmail.com')
#4 PO
organize('Laurent', 'Bossavit', 'laurent@bossavit.com')