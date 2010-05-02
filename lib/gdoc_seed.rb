$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'csv'
require 'configuration'
require 'model'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/db/prod.db'

DAYS = {1 => '2010/05/31', 2 => '2010/06/01'}

def add_schedule_information(session, day, room, scheduled, time)
  begin
    session.scheduled = (scheduled.upcase == 'X')
    session.room = Room.first(:name => room)
    session.scheduled_at = DateTime.parse("#{DAYS[Integer(day)]} #{time}")
  rescue StandardError => e
    puts "failed to add scheduled information to #{session.inspect}, #{e}"
  end
end

CSV.foreach(File.join(File.dirname(__FILE__), '../cosel-agile-france-2010.csv')) do |csv|
  scheduled = csv[0]
  key = csv[1]
  vote = csv[24]
  room = csv[9]
  day = csv[10]
  time = csv[11]
  capacity = csv[14]
  session = Session.first(:key => key)
  if session
    session.vote = vote
    if scheduled
      add_schedule_information(session, day, room, scheduled, time)
    end
    session.capacity = capacity
    session.save!
  end
end