require "spec_helper.rb"
require "model"

describe 'Session' do
  describe 'duration' do
    it 'be deduced from category' do
      Session.new(:category => 'BWORKSHOP').duration.should == 180
    end
  end
end
