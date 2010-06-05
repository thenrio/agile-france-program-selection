#encoding: utf-8
require 'renderable'

class Renderer
include Renderable

  def render(template, locals={})
    content = do_render(template, locals)
    return yield content if block_given?
    content
  end

  def write(content, file_name='sessions.html', output_dir=self.output_dir)
    f = File.join(output_dir, file_name)
    File.open(f, 'w+:UTF-8') do |file|
      file.write content
    end
    puts "wrote #{content.length} to #{f}"
  end


  class Erb < Renderer
    require 'erb'
    def do_render(template, locals={})
      erb = ERB.new(read_template(template))
      inject_locals(locals)
      erb.result get_binding
    end

    def inject_locals(hash)
      hash.each_pair do |key, value|
        symbol = key.to_s
        class << self;self;end.module_eval("attr_accessor :#{symbol}")
        self.send :instance_variable_set, "@#{symbol}", value
      end
      self
    end

    def get_binding
      binding
    end
  end

  class Hml < Renderer
    require 'haml'
    def do_render(template, locals={})
      haml = Haml::Engine.new(read_template(template), :escape_html => true)
      haml.render(Object.new, locals)
    end    
  end
end
