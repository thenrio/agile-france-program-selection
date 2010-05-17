require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/invoice'
require 'model/attendee'
require 'model/invoiceable'
require 'configuration'

describe Attendee do
  before do
    Configuration.new.test
    @google = Company.create(:name => 'google')
    @john_doe = Attendee.create(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.com', :company => @google)
  end

  describe 'John Doe' do
    it 'entrance should be invoiceable' do
      @john_doe.invoiceables.should == [Invoiceable.new(:attendee => @john_doe)]
    end
    it 'entrance invoiceable should have John as attendee' do
      @john_doe.invoiceables.first.attendee.should == @john_doe
    end

    describe 'when early,' do
      before do
        @john_doe.early = true
      end
      it 'should have an invoiceable early entrance' do
        @john_doe.invoiceables.should == [Invoiceable.new(:invoicing_system_id => 'AGF10P220', :attendee => @john_doe)]
      end
    end

    describe 'when attending diner,' do
      before do
        @john_doe.diner = true
      end
      it 'should have a invoiceable diner' do
        @john_doe.invoiceables.should == [Invoiceable.new(:attendee => @john_doe), Invoiceable.new(:invoicing_system_id => 'AGF10D40', :attendee => @john_doe)]
      end
    end

    describe 'when invited by organisation,' do
      before do
        @john_doe.redeemable_coupon = 'ORGANIZATION'
        @john_doe.diner?.should be_false
      end

      it 'should be invoiced with AGF10P0' do
        @john_doe.invoiceables.should == [Invoiceable.new(:invoicing_system_id => 'AGF10P0', :attendee => @john_doe)]
      end

      describe 'with diner,' do
        before do
          @john_doe.diner = true
        end

        it 'should have AGF10D0' do
          @john_doe.invoiceables.last.should == Invoiceable.new(:invoicing_system_id => 'AGF10D0', :attendee => @john_doe)
        end
      end
    end

    describe 'with ORGANIZATION redeemable_coupon,' do
      it 'entrance should be invoiced with AGF10P0' do
        @john_doe.update(:redeemable_coupon => 'ORGANIZATION')
        @john_doe.invoiceables.should == [Invoiceable.new(:invoicing_system_id => 'AGF10P0', :attendee => @john_doe)]
      end
      it 'diner should be invoiced with AGF10D40' do
        @john_doe.update(:redeemable_coupon => 'ORGANIZATION', :diner => true)
        @john_doe.invoiceables.last.should == Invoiceable.new(:invoicing_system_id => 'AGF10D0', :attendee => @john_doe)
      end
    end

    describe ' when entrance is already invoiced' do
      before do
        @invoice = Invoice.new(:company => @john_doe.company)
        entrance = Invoiceable.new(:invoicing_system_id => 'AGF10P270', :attendee => @john_doe)
        @invoice.invoiceables.push(entrance)
        @invoice.save
      end

      it 'should have no more invoiceables' do
        @john_doe.invoiceables.should == []
      end
    end
  end
end
