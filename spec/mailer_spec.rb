#encoding: utf-8
require "spec_helper"
require 'mailer'
require 'configuration'

describe 'Mailer' do
  before do
    @mailer = Mailer.new

    Configuration.new.test

    Mail.defaults do
      delivery_method :test
    end
  end

  describe 'mail_speaker_having_at_least_one_scheduled_session' do
    before do
      @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.org')
      @speaker.save
      s1 = Session.new(:title => 'diner', :speaker => @speaker, :scheduled => true)
      s1.save
      @sessions = [s1]
    end

    it 'should send to John Doe' do
      mails = @mailer.mail_speaker_having_at_least_one_scheduled_session
      mails.length.should == 1
      mail = mails[0]
      mail.from.should == ['orga@conf.agile-france.org']
      mail.to.should == [@speaker.email]
      mail.subject.should == 'vous avez une session retenue au programme de la conférence Agile France'
    end
  end
end