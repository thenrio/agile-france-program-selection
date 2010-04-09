require "spec_helper.rb"
require "model"

describe 'Speaker' do
  describe 'full_name' do
    it 'should be John Doe' do
      speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe')
      speaker.full_name.should == 'John Doe'
    end
  end
end
