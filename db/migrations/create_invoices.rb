require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'dm-migrations/migration_runner'
require 'model/invoice'
require 'model/company'
require 'model/invoiceable'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration #{File.basename(__FILE__)}")

migration 20, :create_invoice do
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