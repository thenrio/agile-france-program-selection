$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'renderer'
require 'pager'

def render_category(render, category)
  sessions = Session.all(:category => category, :order => [:vote.desc])
  sessions_per_unit_of_times = Pager.paginate(sessions, 360)

  sessions_per_unit_of_times.each_with_index do |ss, index|
    render.render_sessions_with_template(ss, 'sessions-with-your-hands.html.erb') do |content|
      render.write(content, "#{category}-#{index}.html")
    end
  end
end

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
render = Renderer.new

# and what about some rake task ?
# will look better...
Session::Category.all do |category|
  render_category(render, category)
end


