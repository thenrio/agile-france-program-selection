require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'rr'
require 'nokogiri'
require 'connector/xero'
require 'model/invoice'
require 'invoice/invoiceable'

describe Connector::Xero do
  before do
    @options = {}
    @consumer = 'consumer'
    @secret = 'secret'

    @connector = Connector::Xero.new(@consumer, @secret, @options)
  end

  describe 'access_token' do
    # will have to go and see this code once again
    # there is smell in creating a new 'irritating' dependency on a method
    # though, value expected is COC
    #
    # use plain object 'token' rather than mock!
    # hence can not make it a fixture for any more functionality
    #
    # following fails with rr-0.10.11
    #
    #describe 'rr' do
    #  it 'shouldn't mock! equals self ?' do
    #    o = mock!
    #    o.should == o
    #  end
    #end
    #
    # is it important ?
    # no
    it 'should initialize token with appropriate parameters' do
      consumer, @token = 'hello', 'there'
      mock(OAuth::Consumer).new(@consumer, @secret, @options) { consumer }
      mock(OAuth::AccessToken).new(consumer, @consumer, @secret) { @token }
      @connector.access_token.should == @token
    end

    it 'should reuse existing token' do
      token = Object.new
      @connector.access_token = token
      @connector.access_token.should equal token
    end
  end


  describe 'create_invoice' do
    before do
      @company = Company.new(:name => 'no name', :email => 'no@name.com')
      @invoiceables = [Invoiceable.new('foo', 10), Invoiceable.new('moo', 3)]
    end
    it 'should build minimal xml' do
      xml = @connector.create_invoice(@company, @invoiceables)
      debugger
      doc = Nokogiri::XML(xml)
      doc.xpath('/Invoice/Type').first.content.should == 'ACCREC'
      doc.xpath('/Invoice/Contact/Name').first.content.should == 'no name'
      doc.xpath('/Invoice/Contact/Date').first.content.should == '2010-05-10'
      doc.xpath('/Invoice/Contact/DueDate').first.content.should == '2010-05-25'
    end
  end
end


