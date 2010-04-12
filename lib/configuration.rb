require 'dm-core'

class Configuration
  def initialize(options={})
    yield self if block_given?
  end

  def path=(path)
    DataMapper.setup(:default, "sqlite3://#{path}")
  end
end



