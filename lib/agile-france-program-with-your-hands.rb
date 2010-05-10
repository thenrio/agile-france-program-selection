$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model/program'
require 'renderer'
require 'pager'
require 'fileutils'

def render_category(renderer, category)
  sessions = Session.all(:category => category, :order => [:vote.desc])
  sessions_per_unit_of_times = Pager.paginate(sessions, 360)

  sessions_per_unit_of_times.each_with_index do |ss, index|
    renderer.render('sessions-with-your-hands.html.erb', :sessions => ss) do |content|
      renderer.write(content, "#{category}-#{index}.html")
    end
  end
end

def copy_css_to_output_directory
  include Renderable
  include FileUtils
  mkdir_p output_dir
  cp_r File.join(template_dir, 'css'), output_dir
end

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
renderer = Renderer::Erb.new

copy_css_to_output_directory()

# and what about some rake task ?
# will look better...
Session::Category.all do |category|
  render_category(renderer, category)
end
