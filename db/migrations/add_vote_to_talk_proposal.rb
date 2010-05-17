$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'dm-migrations/migration_runner'

require 'configuration'
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug( "Starting Migration" )


migration 1, :add_vote_to_talk_proposal do
  up do
    modify_table :talk_proposal do
      add_column :vote, Float, :default => 0
    end
  end

  down do
    modify_table :talk_proposal do
      drop_column :vote
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