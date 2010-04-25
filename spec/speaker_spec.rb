require "spec_helper.rb"
require "model"
require 'configuration'


describe 'Speaker' do
  before do
    Configuration.new.test
    @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.org')
    @speaker.save!
    @s1 = Session.new(:title => 'diner', :speaker => @speaker, :scheduled => true)
    @s1.save!
    @s2 = Session.new(:title => 'pub', :speaker => @speaker)
    @s2.save!
    @sessions = [@s1, @s2]
  end
  describe 'full_name' do
    it 'should be John Doe' do
      @speaker.full_name.should == 'John Doe'
    end
  end

  describe 'scheduled_sessions' do
    it 'should be sessions scoped by scheduled' do
      @speaker.scheduled_sessions.should == [@s1]    
    end
  end
end
