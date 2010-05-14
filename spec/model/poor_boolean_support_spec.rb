require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'dm-core'
require 'model/poor_boolean_support'

class Bird
  include DataMapper::Resource
  extend PoorBooleanSupport
  property :id, Serial
  property :name, String
  property :early, Integer, :default => 0

  quack_on_question_mark :early
end



describe Bird do
  before do
    DataMapper.setup(:default, 'sqlite3::memory:')
    Bird.auto_migrate!
  end
  it '1 should be true' do
    goose = Bird.create(:name => 'goose', :early => 1)
    goose.early?.should be_true
  end

  it '0 should not be true' do
    goose = Bird.create(:name => 'goose', :early => 0)
    goose.early?.should_not be_true
  end

  it 'nil should not be true' do
    goose = Bird.create(:name => 'goose', :early => nil)
    goose.early?.should_not be_true
  end
end