$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'csv'
require 'configuration'
require 'model'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/prod.db'
CSV.foreach(File.join(File.dirname(__FILE__), '../cosel-agile-france-2010.csv')) do |csv|
  scheduled = csv[0]
  key = csv[1]
  vote = csv[20]
  session = Session.first(:key => key)
  if session
    session.vote = vote
    session.scheduled = scheduled.casecmp('X') if scheduled
    session.save!
  end
end