require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/company'
require 'model/attendee'
require 'model/invoiceable'
require 'configuration'

describe 'Company google, ' do
  before do
    Configuration.new.test
    @john = Attendee.new()
    @john.save
    @bob = Attendee.new()
    @bob.save
    @google = Company.new(:name => 'google')
    @google.attendees.push @john, @bob
    @google.save
  end

  describe 'having John and Bob as employee' do
    describe 'invoiceables' do
      it 'should be John\'s and Bob invoiceables' do
        stub(@john).invoiceables {[1,2]}
        stub(@bob).invoiceables {[1,3]}
        @google.invoiceables.should == [1,2,1,3]
      end
    end
  end
end
