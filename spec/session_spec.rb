require "spec_helper.rb"
require "model"

describe 'Session' do
  describe 'duration' do
    it 'be deduced from category' do
      Session.new(:category => 'BWORKSHOP').duration.should == 180
    end
  end

  describe 'Category.all' do
    before do
      @categories = ['BWORKSHOP', 'KEYNOTE', 'OTHER', 'REX', 'TALK', 'WORKSHOP']
    end
    it 'should return' do
      Session::Category.all.should == @categories
    end

    it 'should yield available categories to given block' do
      spy = []
      Session::Category.all do |c|
        spy << c
      end
      spy.should == @categories
    end
  end
end
