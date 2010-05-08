require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'rr'
require 'invoice/payment'

describe Payment do
  describe 'default values' do
    before do
      @payment = Payment.new
    end
    it 'should have default code AGF10P270' do
      @payment.code.should == 'AGF10P270'
    end
    it 'should have default quantity 1' do
      @payment.quantity.should == 1
    end
  end
end