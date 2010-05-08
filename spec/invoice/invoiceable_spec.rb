require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'rr'
require 'invoice/invoiceable'

describe Invoiceable do
  describe 'default values' do
    before do
      @good = Invoiceable.new
    end
    it 'should have default code AGF10P270' do
      @good.code.should == 'AGF10P270'
    end
    it 'should have default quantity 1' do
      @good.quantity.should == 1
    end
  end
end