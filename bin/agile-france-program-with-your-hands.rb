require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
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



# and what about some rake task ?
# will look better...
copy_css_to_output_directory()

renderer = Renderer::Erb.new
Session::Category.all do |category|
  render_category(renderer, category)
end
