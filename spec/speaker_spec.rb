require "spec_helper.rb"
require "model/program"
require 'configuration'


describe 'Speaker' do
  before do
    Configuration.new.test
    @john = Speaker.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.org')
    @john.save!
    @s1 = Session.new(:title => 'diner', :speaker => @john, :scheduled_at => DateTime.now)
    @s1.save!
    @s2 = Session.new(:title => 'pub', :speaker => @john)
    @s2.save!
    @eddy = Speaker.new(:firstname => 'Eddy', :lastname => 'Doe', :email => 'eddy@doe.org')
    @eddy.save!
    @s3 = Session.new(:title => 'beer', :speaker => @eddy)
    @s3.save!
    @sessions = [@s1, @s2]
  end
  describe 'full_name' do
    it 'should be John Doe' do
      @john.full_name.should == 'John Doe'
    end
  end

  describe 'scheduled_sessions' do
    it 'should be sessions scoped by scheduled' do
      @john.scheduled_sessions.should == [@s1]
    end
  end

  describe 'unscheduled_sessions' do
    it 'should be sessions scoped by scheduled' do
      @john.unscheduled_sessions.should == [@s2]
    end
  end

  describe 'Speaker.scheduled' do
    it 'should be John' do
      Speaker.scheduled.size.should == 1
      Speaker.scheduled.first.should == @john
    end
  end

  describe 'Speaker.unscheduled' do
    it 'should be John and Eddy' do
      Speaker.unscheduled.size.should == 2
      Speaker.unscheduled.get(@john.id).should == @john
      Speaker.unscheduled.get(@eddy.id).should == @eddy
    end
  end
end
