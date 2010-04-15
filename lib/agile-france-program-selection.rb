$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'render'

def split(sessions, duration)
  split = []
  chunk = nil
  d = 0
  sessions.each do |session|
    d += session.duration
    if d % duration == 0
      chunk = nil
    end
    if chunk
      chunk << session
    else
      split << (chunk = [])
    end
  end
  split
end

def render_category(render, category)
  sessions = Session.all(:category => category)
  sessions_per_unit_of_times = split(sessions, 360)

  sessions_per_unit_of_times.each_with_index do |ss, index|
    render.render_sessions_with_template(ss, 'sessions.html.erb') do |content|
      render.write(content, "#{category}-#{index}.html")
    end
  end
end

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/prod.db'
render = Renderer.new

Session::Category.all do |category|
  render_category(render, category)
end


