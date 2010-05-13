$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'dm-migrations/migration_runner'
require 'model/invoice'
require 'model/company'
require 'model/invoiceable'

require 'configuration'
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

migration 5, :create_invoice do
  up do
    Invoice.auto_migrate!
  end

  down do
    drop_table :invoices
  end
end

if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end