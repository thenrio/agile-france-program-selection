#encoding: utf-8
require 'configuration'
require 'model'
require 'erb'
require 'fileutils'

class Renderer
  include FileUtils

  def initialize()
    mkdir_p output_dir
  end

  def output_dir
    File.join(home_dir, 'output')
  end

  def home_dir
    File.join(File.dirname(__FILE__), '..')  
  end
  
  def read_template(template)
    File.read(File.join(home_dir, 'templates', template))
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

  def clear(index)
    index % 3 == 0
  end
end
