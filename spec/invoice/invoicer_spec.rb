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
      @google = Company.new().tap { |it| it.save }
      @john = Attendee.new(:company => @google).tap { |it| it.save }
    end

    describe 'when declared in invoicing system,' do
      before do
        @google.invoicing_id = '1234567890'
        invoice = @google.create_invoice
        stub(@invoicer.connector).put_invoice(invoice) {
          invoice.invoice_id = '123'
          invoice
        }
      end

      describe 'invoicing' do
        it 'should tell connector to invoice john\'s invoiceables' do
          @invoicer.invoice_company @google

          invoice = Invoice.first
          invoice.company.should == @google
          entrance = invoice.invoiceables[0]
          entrance.invoice_item_id.should == 'AGF10P270'
          entrance.attendee.should == @john
        end

        it 'should not tell connector to put google as a company' do
          dont_allow(@invoicer.connector).put_company(@google)
          @invoicer.invoice_company @google
        end
      end
    end

    describe 'when not declared in invoicing system,' do
      describe 'create_company' do
        it 'should save contact invoicing id in company' do
          stub(@invoicer.connector).post_contact(@google) {
            @google.invoicing_id = '1234567890'
            @google
          }
          @invoicer.create_company @google
          Company.get(@google.id).invoicing_id.should == '1234567890'
        end
      end
    end
  end
end