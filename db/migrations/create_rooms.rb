$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'dm-migrations/migration_runner'
require 'model/program'

require 'configuration'
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

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