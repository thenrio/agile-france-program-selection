$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'dm-migrations/migration_runner'
require 'configuration'
require 'model/invoiceable'
require 'model/invoice'
require 'model/attendee'
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

migration 4, :create_invoiceables do
  up do
    Invoiceable.auto_migrate!
  end

  down do
    drop_table :invoiceables
  end
end

if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end