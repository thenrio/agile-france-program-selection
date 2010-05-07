$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'dm-migrations/migration_runner'
require 'configuration'
require 'model/invoice'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

migration 2, :create_invoice do
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