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

  describe 'price' do
    it 'should be 220 for early AGF10P220' do
      Invoiceable.new('AGF10P220').price.should == 220  
    end
    it 'should be 270 for early AGF10P270' do
      Invoiceable.new('AGF10P270').price.should == 270
    end
    it 'should be set' do
      Invoiceable.new('special', 1, 65).price.should == 65
    end
  end
end