require "spec"
require 'render'

describe 'clear' do
  it "should be true each 3" do
    clear(0).should be_true
    clear(1).should be_false
    clear(2).should be_false
    clear(3).should be_true
  end
end