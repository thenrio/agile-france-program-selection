require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dm-core'
require 'model/poor_boolean_support'

class Bird
  include DataMapper::Resource
  extend PoorBooleanSupport
  property :id, Serial
  property :name, String
  property :early, Integer, :default => 0

  support_bloody_boolean :early
end



describe Bird do
  before do
    DataMapper.setup(:default, 'sqlite3::memory:')
    Bird.auto_migrate!
  end
  it '1 should be true' do
    goose = Bird.create(:name => 'goose', :early =>1)
    goose.early?.should == true
  end

end