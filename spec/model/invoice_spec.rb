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
    it 'should not be emty?' do
      invoice = Invoice.new()
      invoice.invoiceables << Invoiceable.new
      invoice.empty?.should_not be_true
    end
  end
end