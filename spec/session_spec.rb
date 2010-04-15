require "spec_helper.rb"
require "model"

describe 'Session' do
  describe 'an instance' do
    before do
      @session = Session.new
    end
    describe 'duration' do
      it 'should be deduced from category' do
        Session.new(:category => 'BWORKSHOP').duration.should == 180
      end
    end

    describe 'shuhari' do
      def level_should_be(level, shuhari)
        @session.level = level
        @session.shuhari.should == shuhari
      end
      it 'ADVANCED should be ri' do
        level_should_be 'ADVANCED', 'ri'
      end
      it 'INTERMEDIATE should be ri' do
        level_should_be 'INTERMEDIATE', 'ha'
      end
      it 'BEGINNER should be ri' do
        level_should_be 'BEGINNER', 'shu'
      end
      it 'else should be blank' do
        level_should_be 'ALL', ''
      end
    end
  end

  describe 'Category.all' do
    before do
      @categories = ['BWORKSHOP', 'KEYNOTE', 'OTHER', 'REX', 'TALK', 'WORKSHOP']
    end
    it 'should return available categories' do
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
