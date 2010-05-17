require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require 'model/program'
require 'renderer'

render = Renderer.new

scheduled_sessions = Session.all(:scheduled_at.not => nil, :order => [:scheduled_at.asc])
day_one = scheduled_sessions.select {|session| session if session.scheduled_at.day == 31}

render.render(day_one, 'program.html.erb') do |content|
  render.write(content, 'program.html')
end



