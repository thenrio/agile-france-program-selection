$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'dm-migrations/migration_runner'

require 'configuration'
Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration")

migration 2, :add_redeemable_coupon_to_attendees do
  up do
    modify_table :registration_attendee do
      add_column :redeemable_coupon, String
    end
  end

  down do
    modify_table :registration_attendee do
      drop_column :redeemable_coupon
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