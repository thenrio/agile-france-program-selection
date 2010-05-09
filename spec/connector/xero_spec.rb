require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
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

  class HttpDuck
    attr_accessor :code, :body
    def initialize(code=200, body='')
      self.code = code
      self.body = body
    end
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

  describe 'put_invoice' do
    before do
      @access_token = mock!
      @connector.access_token = @access_token

      @company = Company.new(:name => 'no name', :firstname => 'john', :lastname => 'doe', :email => 'john@doe.com')
      @connector.date = Date.parse('10/05/2010')
      @invoiceables = [Invoiceable.new('foo', 10), Invoiceable.new('moo', 3)]

      stub(@company).invoiceables { @invoiceables }
      stub(@connector).create_invoice(@company, @invoiceables) { 'invoice' }
      stub(@connector).parse_response(anything) { '123' }
    end

    it 'should tell connector to put' do
      mock(@access_token).put('https://api.xero.com/api.xro/2.0/Invoice', 'invoice') {HttpDuck.new(200)}
      invoice = @connector.put_invoice(@company)
      invoice.invoice_id.should == '123'
    end
  end

  describe 'create_invoice' do
    before do
      @company = Company.new(:name => 'no name', :firstname => 'john', :lastname => 'doe', :email => 'john@doe.com')
      @connector.date = Date.parse('10/05/2010')
      @invoiceables = [Invoiceable.new('foo', 10, 1)]
    end
    it 'should build minimal xml' do
      xml = @connector.create_invoice(@company, @invoiceables)
      puts xml
      doc = Nokogiri::XML(xml)
      doc.xpath('/Invoice/Type').first.content.should == 'ACCREC'
      doc.xpath('/Invoice/Contact/Name').first.content.should == 'no name'
      doc.xpath('/Invoice/Contact/FirstName').first.content.should == 'john'
      doc.xpath('/Invoice/Contact/LastName').first.content.should == 'doe'
      doc.xpath('/Invoice/Contact/EmailAddress').first.content.should == 'john@doe.com'
      doc.xpath('/Invoice/Date').first.content.should == '20100510'
      doc.xpath('/Invoice/DueDate').first.content.should == '20100525'
      foo = doc.xpath('/Invoice/LineItems/LineItem')[0]
      foo.xpath('Description').first.content.should == 'foo'
      foo.xpath('Quantity').first.content.should == '10'
      foo.xpath('UnitAmount').first.content.should == '1'
      foo.xpath('AccountCode').first.content.should == 'AGFSI'
    end
  end
  
  describe 'parse_response' do
    it 'should extract InvoiceNumber from happy xml, under xpath' do
      xml = <<XML
<Response>
  <Status>OK</Status>
  <Invoices>
    <Invoice>
      <InvoiceNumber>INV-0011</InvoiceNumber>
    </Invoice>
  </Invoices>
</Response>
XML
      response = HttpDuck.new(200, xml)
      @connector.parse_response(response).should == 'INV-0011'
    end

    it 'should extract error message when service fails' do
      xml = <<XML
<ApiException>
  <ErrorNumber>10</ErrorNumber>
  <Type>ValidationException</Type>
  <Message>A validation exception occurred</Message>
  <Elements>
    <DataContractBase xsi:type="Invoice">
      <ValidationErrors>
        <ValidationError>
          <Message>Email address must be valid.</Message>
        </ValidationError>
      </ValidationErrors>
      <Reference />
      <Type>ACCREC</Type>
      <Contact>
        <ValidationErrors>
          <ValidationError>
            <Message>Email address must be valid.</Message>
          </ValidationError>
        </ValidationErrors>
    </DataContractBase>
  </Elements>
</ApiException>
XML
      response = HttpDuck.new(400, xml)
      lambda{@connector.parse_response(response)}.should raise_error RuntimeError, "Email address must be valid."
    end
  end
end