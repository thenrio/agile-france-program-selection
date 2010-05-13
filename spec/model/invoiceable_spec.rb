#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/company'
require 'model/attendee'
require 'model/invoiceable'

describe Invoiceable do
  before do
    @git = Company.new(:name => 'git')
    @junio = Attendee.new(:firstname => 'junio', :lastname => 'hamano', :company => @git)

  end

  describe 'description' do
    it 'should ' do
      Invoiceable.new(:attendee => @junio).description.should == 'AGF10P270 - Place pour la conférence - junio hamano'
    end
  end
end