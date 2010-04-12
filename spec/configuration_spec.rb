require "spec_helper"
require 'configuration'
require 'rr'

describe 'configuration' do
  it 'should setup datamapper with file path' do
    mock(DataMapper).setup(:default, 'sqlite3://foo')
    Configuration.new do |c|
      c.path = 'foo'  
    end
  end
end