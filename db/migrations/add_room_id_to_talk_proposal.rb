require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'dm-migrations/migration_runner'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration #{File.basename(__FILE__)}")

migration 10, :add_room_id_to_talk_proposal do
  up do
    modify_table :talk_proposal do
      add_column :room_id, Integer
    end
  end

  down do
    modify_table :talk_proposal do
      drop_column :room_id
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