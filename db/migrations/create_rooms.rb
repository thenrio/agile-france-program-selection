require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'dm-migrations/migration_runner'
require 'model/program'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration #{File.basename(__FILE__)}")

migration 20, :create_rooms do
  up do
    Room.auto_migrate!
  end

  down do
    drop_table :rooms
  end
end

if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end