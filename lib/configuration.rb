require 'dm-core'
require 'dm-aggregates'

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
    require 'dm-migrations'
    require 'model/invoice'
    require 'model/invoiceable'
    require 'model/attendee'
    require 'model/company'
    require 'model/program'
    require 'model/sent_mail'
    Room.auto_migrate!
    Speaker.auto_migrate!
    Session.auto_migrate!
    Company.auto_migrate!
    Attendee.auto_migrate!
    Invoice.auto_migrate!
    Invoiceable.auto_migrate!
    SentMail.auto_migrate!
    self
  end
end