require 'dm-core'

class Configuration
  def initialize(options={})
    self.path = options[:path] if options[:path]
    yield self if block_given?
  end

  def path=(path)
    DataMapper.setup(:default, "sqlite3://#{path}")
  end

  def test
    DataMapper.setup(:default, 'sqlite3::memory:')
    require 'model/invoice'
    require 'model/invoiceable'
    require 'model/attendee'
    require 'model/company'
    require 'model/program'
    Speaker.auto_migrate!
    Session.auto_migrate!
    Company.auto_migrate!
    Attendee.auto_migrate!
    Invoice.auto_migrate!
    Invoiceable.auto_migrate!
    self
  end
end