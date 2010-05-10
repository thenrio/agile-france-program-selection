#encoding: utf-8
require 'configuration'
require 'model/program'
require 'erb'
require 'renderable'

class Renderer
  include Renderable

  def render(template, locals={})
  end

  def write(content, file_name='sessions.html', output_dir=self.output_dir)
    f = File.join(output_dir, file_name)
    File.open(f, 'w+') do |file|
      file.write content
    end
    puts "wrote #{content.length} to #{f}"
  end


  class Erb < Renderer
    def render(template, locals={})
      erb = ERB.new(read_template(template))
      inject_locals(locals)
      content = erb.result get_binding
      if block_given?
        return yield content
      end
      content
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
end
