require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/company'
require 'model/attendee'
require 'invoice/invoiceable'
require 'configuration'

describe 'Company google, ' do
  before do
    Configuration.new.test
    @google = Company.new(:name => 'google')
    @google.save
    @john = Attendee.new(:company => @google)
    @john.save
    @bob = Attendee.new(:company => @google)
    @bob.save
  end

  describe 'having John and Bob as employee' do
    describe 'invoiceables' do
      it 'should be John\'s and Bob invoiceables' do
        stub(@john).invoiceables {[1,2]}
        stub(@bob).invoiceables {[1,3]}
#        @google.invoiceables.should == [1,2,1,3]
      end
    end
  end
end
