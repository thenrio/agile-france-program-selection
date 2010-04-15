$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'render'

def render_category(render, category)
  sessions = Session.all(:category => category)
  render.render_sessions_with_template(sessions, 'sessions.html.erb') do |content|
    render.write(content, "#{category}.html")
  end
end

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/prod.db'
render = Renderer.new

Session::Category.all do |category|
  render_category(render, category)
end


