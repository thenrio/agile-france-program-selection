#encoding: utf-8
require "spec_helper"
require 'mailer'
require 'configuration'

def create_seeds
  @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.org')
  @speaker.save
  date = DateTime.parse('2010/05/31 10:30')
  s1 = Session.new(:title => 'diner', :speaker => @speaker, :scheduled => true, :scheduled_at => date)
  s1.save
  s2 = Session.new(:title => 'pub', :speaker => @speaker)
  s2.save
  @sessions = [s1, s2]
end

describe 'Mailer' do
  before do
    @mailer = Mailer.new

    Configuration.new.test

    Mail.defaults do
      delivery_method :test
    end
    Mail::TestMailer.deliveries.clear

    create_seeds()
  end

  describe 'mail_speaker_having_at_least_one_scheduled_session' do
    before do
      @mails = @mailer.mail_speaker_having_at_least_one_scheduled_session
    end

    it 'should make a message to John Doe' do
      @mails.length.should == 1
      mail = @mails[0]
      mail.from.should == ['orga@conf.agile-france.org']
      mail.to.should == [@speaker.email]
      mail.subject.should == 'vous avez une session retenue au programme de la conférence Agile France'
      mail.body.raw_source.should == <<eos
Bonjour John Doe, nous avons regardé vos propositions de session sur http://conf.agile-france.org/
Le comité de sélection a retenu
- diner

Le programme sera publié prochainement

Contactez nous pour toute question, remarque ou contrainte
L'Organisation de la conférence Agile France
eos
    end

    it 'should send it' do
      Mail::TestMailer.deliveries.should == @mails
    end

  end

  describe 'confirm_speaker' do
    before do
      @mails = @mailer.mail_confirm_schedule_time_to_speaker
    end

    it 'should make a message to John Doe' do
      @mails.length.should == 1
      mail = @mails[0]
      mail.from.should == ['orga@conf.agile-france.org']
      mail.to.should == [@speaker.email]
      mail.subject.should == 'heure de vos sessions à la conférence Agile France'
      mail.body.raw_source.should == <<eos
Bonjour John Doe
Nous avons plusieurs information pour vous

== Programmation ==
Nous avons programmé
- diner, le 31/05/2010 à 10:30

Le programme sera en ligne prochainement sur http://conf.agile-france.org/

== Matériel visuel ==
Il y a un logo 'speaker' sur http://github.com/thierryhenrio/agile-france-publicity/blob/master/speaker-2010.png
Le mettre sur un blog, un site, c'est aussi promouvoir l'évènement

== Nous prenons en charge un orateur par session ==
La prise en charge comprend les droits d'entrée pour la conférence et le diner du 31/05
Si vous binomez avec Paul Dupont, Paul Dupont doit s'acquitter des droits d'entrée pour la conférence

Contactez nous pour toute question, remarque ou contrainte
L'Organisation de la conférence Agile France
eos
    end
  end
end
