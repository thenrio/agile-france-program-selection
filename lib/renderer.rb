#encoding: utf-8
require 'configuration'
require 'model/program'
require 'erb'
require 'fileutils'
require 'renderable'

class Renderer
  include FileUtils
  include Renderable

  def initialize()
    mkdir_p output_dir
    cp_r File.join(template_dir, 'css'), output_dir
  end


  def render_sessions_with_template(sessions, template)
    erb = ERB.new(read_template(template))
    content = erb.result binding
    if block_given?
      return yield content
    end
    content
  end

  def write(content, file_name='sessions.html')
    f = File.join(output_dir, file_name)
    File.open(f, 'w+') do |file|
      file.write content
    end
    puts "wrote #{content.length} to #{f}"
  end
end
