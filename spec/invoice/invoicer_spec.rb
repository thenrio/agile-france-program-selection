require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'rr'
require 'invoice/invoicer'
require 'model/invoice'
require 'model/program'

describe Invoicer do
  before do
    @invoicer = Invoicer.new
  end

  it 'should have a connector' do
    @invoicer.connector.should be_nil
  end

  describe 'select_receivable_invoices' do
    before do
      Configuration.new.test
      @google = Company.new(:name => 'google', :firstname => 'john', :lastname => 'doe', :email => 'john@doe.com')
      @google.save
    end

    describe ', with no attendee' do
      it 'should return []' do
        @invoicer.invoice_companies.should == []
      end
    end

    describe ', with 1 attendee and 0 invoice' do
      before do
        @john = Attendee.new(:firstname => 'john', :lastname => 'doe', :email => 'john@doe.com', :company => @google)
        @john.save
      end

      it 'should return john#payments' do
        @invoicer.invoice_companies.should == [Payment.new(:standard, 1)]
      end
    end
  end
end