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
  describe 'access_token' do
    before do
      consumer, @token = 'hello', 'there'
      mock(OAuth::Consumer).new(@consumer, @secret, @options) {consumer}
      mock(OAuth::AccessToken).new(consumer, @consumer, @secret) {@token}
    end

    it 'should initialize token with appropriate parameters' do
      @connector.access_token.should == @token
    end
  end
end