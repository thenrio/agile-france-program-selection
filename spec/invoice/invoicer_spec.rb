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
      @google = Company.create
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

        it 'should not tell connector to put empty invoice' do
          stub(@google).invoiceables { [] }
          dont_allow(@invoicer.connector).post_invoice(anything)
          @invoicer.invoice_company @google
        end
      end
    end

    describe 'when not declared in invoicing system,' do
      describe 'create_company' do
        it 'should save contact invoicing id in company' do
          stub(@invoicer.connector).post_contact(@google) {
            @google.invoicing_system_id = '1234567890'
            @google
          }
          @invoicer.create_company @google
          Company.get(@google.id).invoicing_system_id.should == '1234567890'
        end
      end
    end
  end

  describe 'get_available_companies' do
    it 'should tell connector to get contacts' do
      a_sis = Company.new(:name => 'a-SIS')
      mock(@invoicer.connector).get_contacts {
        [a_sis]
      }
      @invoicer.get_available_companies.should == {'a-sis' => a_sis}
    end
  end
end