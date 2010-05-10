require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/invoice'
require 'model/attendee'
require 'invoice/invoiceable'
require 'configuration'

describe Attendee do
  before do
    Configuration.new.test
    @google = Company.new(:name => 'google')
    @google.save
    @john_doe = Attendee.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.com', :company => @google)
    @john_doe.save
  end

  describe 'John Doe' do
    it 'entrance should be invoiceable' do
      @john_doe.invoiceables.should == [Invoiceable.new]
    end
    it 'entrance invoiceable should have John as attendee' do
      @john_doe.invoiceables.first.attendee.should == @john_doe
    end

    describe 'when early,' do
      before do
        @john_doe.early = true
      end
      it 'should have an invoiceable early entrance' do
        @john_doe.invoiceables.should == [Invoiceable.new('AGF10P220')]
      end
    end

    describe 'when attending diner,' do
      before do
        @john_doe.diner = true
      end
      it 'should have a invoiceable diner' do
        @john_doe.invoiceables.should == [Invoiceable.new, Invoiceable.new('AGF10D40')]
      end
    end

    describe 'when invited by organisation,' do
      before do
        @john_doe.invited_by = 'ORGANIZATION'
        @john_doe.diner?.should be_false
      end

      it 'should be invoiced with AGF10P0' do
        @john_doe.invoiceables.should == [Invoiceable.new('AGF10P0')]
      end

      describe 'with diner,' do
        before do
          @john_doe.diner = true
        end

        it 'should have AGF10D0' do
          @john_doe.invoiceables.last.should == Invoiceable.new('AGF10D0')
        end
      end
    end

    describe ' when entrance is already invoiced' do
      before do
        @invoice = Invoice.new(:company => @john_doe.company)
        entrance = InvoiceItem.new(:invoice_item_id => 'AGF10P270', :attendee => @john_doe)
        @invoice.invoice_items.push(entrance)
        @invoice.save
      end

      it 'should have no more invoiceables' do
        @john_doe.invoiceables.should == []
      end
    end
  end
end
