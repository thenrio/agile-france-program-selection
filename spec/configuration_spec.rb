require "spec_helper"
require 'configuration'
require 'rr'

describe 'configuration' do
  after do
  end

  it 'should setup datamapper with file path' do
    mock(DataMapper).setup(:default, 'sqlite3://foo')
    Configuration.new do |c|
      c.path = 'foo'
    end
  end

  it 'should use alternate options to setup datamapper' do
    mock(DataMapper).setup(:default, 'sqlite3://moo')
    Configuration.new :path => 'moo'
  end
end