require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'rr'
require 'nokogiri'
require 'connector/xero'
require 'model/invoice'
require 'model/invoiceable'

describe Connector::Xero do
  before do
    @options = {}
    @consumer = 'consumer'
    @secret = 'secret'

    @connector = Connector::Xero.new(@consumer, @secret, @options)
    Configuration.new.test
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

  describe 'with invoice,' do
    before do
      company = Company.new(:name => 'no name', :firstname => 'john',
                            :lastname => 'doe', :email => 'john@doe.com',
                            :invoicing_id => 'sha1')
      date = Date.parse('10/05/2010')
      invoiceables = [Invoiceable.new()]
      @invoice = Invoice.new(:company => company, :invoiceables => invoiceables, :date => date)
    end

    describe 'put_invoice' do
      before do
        @access_token = mock!
        @connector.access_token = @access_token

        stub(@connector).create_invoice(@invoice) { 'invoice' }
        stub(@connector).parse_invoice_response(anything) { '123' }
      end

      it 'should tell connector to put' do
        mock(@access_token).put('https://api.xero.com/api.xro/2.0/Invoice', 'invoice') { HttpDuck.new(200) }
        invoice = @connector.put_invoice(@invoice)
        invoice.invoice_id.should == '123'
      end
    end

    describe 'create_invoice' do
      it 'should build minimal xml' do
        xml = @connector.create_invoice(@invoice)
        doc = Nokogiri::XML(xml)
        doc.xpath('/Invoice/Type').first.content.should == 'ACCREC'
        doc.xpath('/Invoice/Contact/ContactID').first.content.should == 'sha1'
        doc.xpath('/Invoice/Date').first.content.should == '2010-05-10'
        doc.xpath('/Invoice/DueDate').first.content.should == '2010-05-25'
        foo = doc.xpath('/Invoice/LineItems/LineItem')[0]
        foo.xpath('Description').first.content.should == 'AGF10P270'
        foo.xpath('Quantity').first.content.should == '1'
        foo.xpath('UnitAmount').first.content.should == '270'
        foo.xpath('AccountCode').first.content.should == '20010AGFI'
      end
    end
  end


  describe 'with a company,' do
    before do
      @company = Company.new(:name => 'no name', :firstname => 'john', :lastname => 'doe', :email => 'john@doe.com')
      @company.id = 123
    end

    describe 'create_company' do
      it 'should tell connector to put company as proper xml' do
        xml = @connector.create_contact(@company)
        doc = Nokogiri::XML(xml)
        doc.xpath('/Contact/Name').first.content.should == 'no name'
        doc.xpath('/Contact/FirstName').first.content.should == 'john'
        doc.xpath('/Contact/LastName').first.content.should == 'doe'
        doc.xpath('/Contact/EmailAddress').first.content.should == 'john@doe.com'
      end
    end

    describe 'put_company' do
      before do
        @access_token = mock!
        @connector.access_token = @access_token

        stub(@connector).create_company(@company) { 'company' }
        stub(@connector).parse_company_response(anything) { '123' }
      end
      it 'should put' do
        company = @connector.put_company(@company)
        company.invoicing_id.should == '123'
      end
    end
  end

  describe 'parse_response' do
    it 'should extract InvoiceNumber from happy xml, under xpath' do
      xml = <<XML
<Response>
  <Invoices>
    <Invoice>
      <InvoiceNumber>INV-0011</InvoiceNumber>
    </Invoice>
  </Invoices>
</Response>
XML
      response = HttpDuck.new(200, xml)
      @connector.parse_invoice_response(response).should == 'INV-0011'
    end

    it 'should extract error message when mail is not valid' do
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
      message = 'A validation exception occurred, Email address must be valid.'
      lambda { @connector.parse_invoice_response(response) }.should raise_error Connector::Xero::Problem, message
    end

    it 'should extract error code and message' do
      xml = <<XML
<ApiException>
  <ErrorNumber>14</ErrorNumber>
  <Type>PostDataInvalidException</Type>
  <Message>The string '20100510' is not a valid AllXsd value.</Message>
</ApiException>
XML
      response = HttpDuck.new(400, xml)
      message = 'The string \'20100510\' is not a valid AllXsd value.'
      lambda { @connector.parse_invoice_response(response) }.should raise_error Connector::Xero::Problem, message
    end
  end
end