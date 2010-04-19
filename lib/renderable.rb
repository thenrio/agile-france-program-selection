module Renderable
  def output_dir
    File.join(home_dir, 'output')
  end

  def home_dir
    File.join(File.dirname(__FILE__), '..')
  end

  def template_dir
    File.join(home_dir, 'templates')
  end

  def read_template(template)
    File.read(File.join(template_dir, template))
  end
end