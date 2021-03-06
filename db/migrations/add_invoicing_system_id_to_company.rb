require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'dm-migrations/migration_runner'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration #{File.basename(__FILE__)}")

migration 10, :add_invoicing_id_to_company do
  up do
    modify_table :registration_company do
      add_column :invoicing_system_id, String
    end
  end

  down do
    modify_table :registration_company do
      drop_column :invoicing_system_id
    end
  end
end

if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end