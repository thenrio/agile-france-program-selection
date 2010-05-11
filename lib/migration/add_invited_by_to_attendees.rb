$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'dm-migrations/migration_runner'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

migration 4, :add_invited_by_to_attendees do
  up do
    modify_table :registration_attendee do
      add_column :invited_by, String
    end
  end

  down do
    modify_table :registration_attendee do
      drop_column :invited_by
    end
  end
end

if $0 == __FILE__
  require 'configuration'
  Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end