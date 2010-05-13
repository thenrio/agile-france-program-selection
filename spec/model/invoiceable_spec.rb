#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/company'
require 'model/attendee'
require 'model/invoice'
require 'model/invoiceable'

describe Invoiceable do
  before do
    @git = Company.new(:name => 'git')
    @junio = Attendee.new(:firstname => 'junio', :lastname => 'hamano', :company => @git)

  end

  describe 'description' do
    it 'should have invoicing system id, textual description of item and attendee full name' do
      Invoiceable.new(:attendee => @junio).description.should == 'AGF10P270 - Place - junio hamano'
    end
  end

  describe 'Invoiceable.description' do
    it 'should be Place for AGF10P270' do
      Invoiceable.describe('AGF10P270').should == 'Place'
    end

    it 'should be Early for AGF10P220' do
      Invoiceable.describe('AGF10P220').should == 'Early'
    end

    it 'should be Place Gratuite for AGF10P0' do
      Invoiceable.describe('AGF10P0').should == 'Place Gratuite'
    end

    it 'should be Diner for AGF10D40' do
      Invoiceable.describe('AGF10D40').should == 'Diner'
    end

    it 'should be Diner Gratuit for AGF10D0' do
      Invoiceable.describe('AGF10D0').should == 'Diner Gratuit'  
    end

    it 'should be empty for foo' do
      Invoiceable.describe('foo').should == ''
    end
  end
end