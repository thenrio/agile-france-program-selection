require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/invoice'
require 'invoice/invoiceable'

describe Attendee do

  describe 'default' do
    before do
      @attendee = Attendee.new
    end

    it 'default should be entrance invoiceable' do
      @attendee.invoiceables.should == [Invoiceable.new]
    end
  end

  describe 'early' do
    before do
      @attendee = Attendee.new(:early => true)
    end

    it 'default should be entrance invoiceable' do
      @attendee.invoiceables.should == [Invoiceable.new('AGF10P220')]
    end
  end
end
