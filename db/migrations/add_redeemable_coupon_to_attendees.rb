require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'dm-migrations/migration_runner'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.logger.debug("Starting Migration #{File.basename(__FILE__)}")

migration 10, :add_redeemable_coupon_to_attendees do
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