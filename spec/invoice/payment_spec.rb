require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'rr'
require 'invoice/payment'

describe Payment do
  describe 'default values' do
    it 'should have default code AGF10P270, and quantity 1' do
      p = Payment.new
      p.code.should == 'AGF10P270'
    end
  end
end