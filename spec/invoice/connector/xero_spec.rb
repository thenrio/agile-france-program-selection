require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'rr'
require 'connector/xero'

describe Connector::Xero do
  before do
    @options = {}
    @consumer = 'consumer'
    @secret = 'secret'

    @connector = Connector::Xero.new(@consumer, @secret, @options)
  end
  describe 'put_invoice' do
    it 'should' do

    end
  end
end