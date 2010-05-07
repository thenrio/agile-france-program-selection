require 'dm-core'

class Configuration
  def initialize(options={})
    self.path = options[:path] if options[:path]
    yield self if block_given?
  end

  def path=(path)
    DataMapper.setup(:default, "sqlite3://#{path}")
#    require 'model'
#    Session.auto_migrate!
#    Speaker.auto_migrate!
  end

  def test
    DataMapper.setup(:default, 'sqlite3:memory')
    Speaker.auto_migrate!
    Session.auto_migrate!
    self
  end
end



