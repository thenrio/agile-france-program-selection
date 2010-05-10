$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'renderer'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
render = Renderer.new


scheduled_sessions = Session.all(:scheduled_at.not => nil, :order => [:scheduled_at.asc])
day_one = scheduled_sessions.select {|session| session if session.scheduled_at.day == 31}

render.render_sessions_with_template(day_one, 'program.html.erb') do |content|
  render.write(content, 'program.html')
end



