require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'rr'
require 'invoice/invoicer'

describe Invoicer do
  before do
    @invoicer = Invoicer.new
  end

  it 'should have a connector' do
    @invoicer.connector.should be_nil
  end
end