require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'configuration'
require 'invoice/invoicer'
require 'model/invoice'
require 'model/company'
require 'model/attendee'
require 'connector/base'

describe 'an Invoicer,' do
  before do
    @invoicer = Invoicer.new
  end

  it 'should have a default connector' do
    @invoicer.connector.should be_instance_of Connector::Base
  end


  describe 'with google,' do
    before do
      Configuration.new.test
      @google = Company.create(:name => 'google')
      @john = Attendee.create(:company => @google)
    end

    describe 'when declared in invoicing system,' do
      before do
        @google.invoicing_system_id = '1234567890'
        invoice = @google.create_invoice
        stub(@invoicer.connector).post_invoice(invoice) {
          invoice.invoicing_system_id = '123'
          invoice
        }
      end

      describe 'invoicing' do
        it 'should tell connector to invoice john\'s invoiceables' do
          @invoicer.invoice_company @google

          invoice = Invoice.first
          invoice.company.should == @google
          entrance = invoice.invoiceables[0]
          entrance.invoicing_system_id.should == 'AGF10P270'
          entrance.attendee.should == @john
        end

        it 'should not tell connector to put google as a company' do
          dont_allow(@invoicer.connector).put_company(@google)
          @invoicer.invoice_company @google
        end

        it 'should not tell connector to put zero? invoice' do
          invoice = Invoice.new
          invoice.invoiceables.push Invoiceable.new(:invoicing_system_id => 'AGF10P0')
          invoice.zero?.should be_true
          stub(@google).create_invoice {invoice}
          dont_allow(@invoicer.connector).post_invoice(anything)
          @invoicer.invoice_company @google
        end
      end
    end

    describe 'when not declared in invoicing system,' do
      before do
        google = @google.clone
        google.invoicing_system_id = '1234567890'
        stub(@invoicer.connector).post_contact(@google) {
          google
        }
      end
      describe 'create_company' do
        before do
          @posted = @invoicer.create_company @google
        end
        it 'should save contact invoicing id in company' do
          @posted.invoicing_system_id.should == '1234567890'
          Company.get(@google.id).should == @posted
        end
        it 'should make posted company available' do
          @invoicer.posted_company(@google).should == @posted
        end
      end
    end

    describe 'create_company,' do
      describe 'with conflicting emails' do
        before do
          @google.email = 'donut'

          google = @google.clone
          google.invoicing_system_id = '1234567890'
          google.email = 'watcha'
          stub(@invoicer).posted_companies { {google.name => google} }
        end
        
        it 'should be idempotent' do
          g1 = @invoicer.create_company(@google)
          g1.invoicing_system_email.should == 'watcha'
          g2 = @invoicer.create_company(@google)
          g2.invoicing_system_email.should == 'watcha'
          g2.should == g1
        end
      end
    end
  end

  describe 'posted_companies' do
    it 'should tell connector to get contacts' do
      a_sis = Company.new(:name => 'a-SIS')
      mock(@invoicer.connector).get_contacts { [a_sis] }
      @invoicer.posted_companies.should == {'a-sis' => a_sis}
    end
  end

  describe 'can_post?,' do
    before do
      def @invoicer.posted_companies
        {'a-sis' => Company.new(:name => 'a-SIS', :invoicing_system_id => '123')}
      end
    end
    it 'is false if company name is available, ignoring case' do
      a_sis = Company.new(:name => 'A-sis')
      @invoicer.can_post?(a_sis).should_not be_true
    end

    it 'is false if company name is available, ignoring leading and trailing spaces' do
      a_sis = Company.new(:name => ' A-sis ')
      @invoicer.can_post?(a_sis).should_not be_true
    end

    it 'is true if company name is not available, ignoring case' do
      assis = Company.new(:name => 'assis')
      @invoicer.can_post?(assis).should be_true
    end
  end

  describe 'merge!' do
    before do
      Configuration.new.test
      @a_sis = Company.create(:name => 'A-SIS', :email => 'good')

      def @invoicer.posted_companies
        {'a-sis' => Company.new(:name => 'a-SIS', :invoicing_system_id => '123', :email => 'bad')}
      end

      @invoicer.merge!(@a_sis).invoicing_system_id.should == '123'
    end

    it 'A-SIS should gain invoicing_system_id' do
      @a_sis.invoicing_system_id.should == '123'
    end

    it 'A-SIS should keep good mail' do
      @a_sis.email.should == 'good'
    end

    it 'A-SIS should have bad_invoicing_system_email' do
      @a_sis.invoicing_system_email.should == 'bad'
    end
  end
end