require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/invoice'
require 'invoice/invoiceable'

describe Attendee do
  before do
    @attendee = Attendee.new
  end


  it 'default entrance should be invoiceable' do
    @attendee.invoiceables.should == [Invoiceable.new]
  end

  describe 'early' do
    before do
      @attendee.early = true
    end
    it 'should be invoiceable' do
      @attendee.invoiceables.should == [Invoiceable.new('AGF10P220')]
    end
  end

  describe 'diner' do
    before do
      @attendee.diner = true
    end
    it 'should be invoiceable' do
      @attendee.invoiceables.should == [Invoiceable.new, Invoiceable.new('AGF10D40')]
    end
  end

  describe 'invited by organisation' do
    before do
      @attendee.invited_by = 'ORGANIZATION'
      @attendee.diner?.should be_false
    end

    it 'should be invoiced with AGF10P0' do
      @attendee.invoiceables.should == [Invoiceable.new('AGF10P0')]
    end

    describe 'with diner' do
      before do
        @attendee.diner = true
      end

      it 'should have AGF10D0' do
        @attendee.invoiceables.last.should == Invoiceable.new('AGF10D0')
      end
    end
  end
end
