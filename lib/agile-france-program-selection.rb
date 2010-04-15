$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'render'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/prod.db'
render = Renderer.new
render.render_sessions_with_template(Session.all, 'sessions.html.erb') do |content|
  render.write content
end
