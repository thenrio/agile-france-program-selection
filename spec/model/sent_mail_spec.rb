require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'model/attendee'
require 'model/company'
require 'configuration'

describe SentMail do
  describe 'should have a person, being evaled person_class.get person_id' do
    before do
      Configuration.new.test
      @foo = Company.create(:email => 'foo@foo.foo')
      @john = Attendee.create(:email => 'john@doe.com')
    end

    it 'should have a foo company as a person' do
      mail = SentMail.new(:person_class => @foo.class, :person_id => @foo.id)
      mail.person.should eql @foo
    end

    it 'should have a john attendee as a person' do
      mail = SentMail.new(:person_class => @john.class, :person_id => @john.id)
      mail.person.should eql @john
    end
  end
end
