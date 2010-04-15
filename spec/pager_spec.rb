require "spec_helper"
require 'pager'
require 'model'

describe 'pager' do

  class SessionStub
    attr_accessor :id
    def duration
      180
    end
    def ==(other)
      self.id == other.id   
    end
    def to_s
      "SessionStub(#{id})"  
    end
  end

  def create_session(id)
    session = SessionStub.new
    session.id = id
    session
  end

  before do
    @s1 = create_session(1)
    @s2 = create_session(2)
    @s3 = create_session(3)
    @s4 = create_session(4)
    @s5 = create_session(5)
  end

  it 'should split an array of 6 long workshop in 3 arrays of 2' do
    Pager.paginate([@s1, @s2, @s3, @s4, @s5], 360).should == [[@s1, @s2], [@s3, @s4], [@s5]]
  end
  it 'should split an array of 1 long workshop in 1 array of 1' do
    Pager.paginate([@s1], 360).should == [[@s1]]
    Pager.paginate([@s1, @s2], 360).should == [[@s1, @s2]]
  end
end