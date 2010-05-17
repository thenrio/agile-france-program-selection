require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'csv'
require 'configuration'
require 'model/program'

DAYS = {1 => '2010/05/31', 2 => '2010/06/01'}

def add_schedule_information(session, day, time, room)
  begin
    session.room = Room.first(:name => room)
    session.scheduled_at = DateTime.parse("#{DAYS[Integer(day)]} #{time}")
  rescue StandardError => e
    puts "failed to add scheduled information to #{session.inspect}, #{e}"
  end
end

def clear_schedule_information(session)
  session.room = nil
  session.scheduled_at = nil
end

CSV.foreach(File.join(File.dirname(__FILE__), '../../cosel-agile-france-2010.csv')) do |csv|
  key = csv[1]
  vote = csv[24]
  room = csv[9]
  day = csv[10]
  time = csv[11]
  capacity = csv[14]
  session = Session.first(:key => key)
  if session
    session.vote = vote
    if room
      add_schedule_information(session, day, time, room)
    else
      clear_schedule_information(session)
    end
    session.capacity = capacity
    session.save!
  end
end