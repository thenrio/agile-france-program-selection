#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/company'
require 'model/attendee'
require 'model/invoice'
require 'model/invoiceable'

describe Invoice do
  describe 'with no invoiceables,' do
    it 'should be emty?' do
      Invoice.new.empty?.should be_true
    end
  end

  describe 'with one invoiceable,' do
    before do
      @invoice = Invoice.new()

    end
    it 'should not be empty?' do
      @invoice.invoiceables << Invoiceable.new
      @invoice.empty?.should_not be_true
    end
  end

  describe 'price,' do
    before do
      @invoice = Invoice.new()
      g = Invoiceable.new().tap {|inv| inv.price = 0}
      i = Invoiceable.new().tap {|inv| inv.price = 220}
      t = Invoiceable.new().tap {|inv| inv.price = 14}
      v = Invoiceable.new().tap {|inv| inv.price = 6}
      @invoice.invoiceables.concat [g, i, t, v]
    end
    it 'should be sum of invoiceables price' do
      @invoice.price.should == 240
    end
  end

describe 'zero?,' do
    before do
      @invoice = Invoice.new()
    end
    it 'should be true if invoice price is 0' do
      stub(@invoice).price {0}
      @invoice.zero?.should be_true
    end
    it 'should be false if invoice price is not 0' do
      stub(@invoice).price {1}
      @invoice.zero?.should_not be_true
    end
  end

  describe 'due_date,' do
    before do
      date = Date.parse('18/05/2010')
      @invoice = Invoice.new(:date => date, :settlement => 10)
    end

    it 'should be date + settlement' do
      @invoice.due_date.should == Date.parse('28/05/2010')
    end
  end
end