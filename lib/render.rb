require 'configuration'
require 'model'
require 'erb'

class Renderer
  def read_template(template)
    File.read(File.join(File.dirname(__FILE__), '..', 'templates', template))
  end

  def render_sessions_with_template(sessions, template)
    erb = ERB.new(read_template(template))
    erb.result binding
  end

  def clear(index)
    index % 3 == 0
  end
end
