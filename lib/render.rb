require 'configuration'
require 'model'
require 'erb'
require 'fileutils'

class Renderer
  include FileUtils::Verbose

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

  def write(content)
    File.open(File.join(output_dir, 'sessions.html'), 'w+') do |file|
      file.write content
    end
  end

  def clear(index)
    index % 3 == 0
  end
end
