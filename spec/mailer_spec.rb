#encoding: utf-8
require "spec_helper"
require 'mailer'
require 'configuration'

def create_seeds
  Speaker.all.destroy!
  Session.all.destroy!
  @speaker = Speaker.new(:firstname => 'John', :lastname => 'Doe', :email => 'john@doe.org')
  @speaker.save
  date = DateTime.parse('2010/05/31 10:30')
  @diner = Session.new(:title => 'diner', :speaker => @speaker, :scheduled_at => date)
  @diner.save
  pub = Session.new(:title => 'pub', :speaker => @speaker)
  pub.save
  @sessions = [@diner, pub]
end

def configure_test_mail
  Mail.defaults do
    delivery_method :test
  end
  Mail::TestMailer.deliveries.clear
end

def configure_test_database
  Configuration.new.test
  create_seeds()
end

describe 'Mailer' do
  before do
    configure_test_mail()
    configure_test_database()
    @mailer = Mailer.new
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
- diner, le 31/05/2010 à 10:30, pour une durée de 60 minutes

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

    it 'should send it' do
      Mail::TestMailer.deliveries.should == @mails
    end
  end

  describe 'ask_for_capacity' do
    describe ', with speaker having session without capacity' do
      before do
        @mails = @mailer.mail_ask_for_capacity
      end

      it 'should make a message to John Doe for diner session' do
        @mails.length.should == 1
        mail = @mails[0]
        mail.from.should == ['orga@conf.agile-france.org']
        mail.to.should == [@speaker.email]
        mail.subject.should == "nombre de participants que vous pouvez accueillir"
        mail.body.raw_source.should == <<eos
Bonjour John Doe
Nous nous sommes aperçu que le nombre de participants n'est pas requis lors de la soumission de session
Et nous aimerions communiquer cette information aux participants

Nos objectifs sont les suivants
- les participants ont accès à cette information pour prendre les bonnes décisions
par exemple, la session 'Audience réduite' a une limite de 20, je vais rejoindre la salle 5 minutes avant,
plutot qu'arriver juste à temps


== Vos sessions ==
Pour les sessions suivantes, avez vous une limite de participation : 50, 40, 30, autre ?
- diner, le 31/05/2010 à 10:30

L'Organisation de la conférence Agile France
eos
      end

      it 'should send it' do
        Mail::TestMailer.deliveries.should == @mails
      end
    end

    describe ', with speaker having scheduled session with capacity' do
      before do
        @diner.capacity = 10
        @diner.save!
        @mails = @mailer.mail_ask_for_capacity
      end


      it 'should not mail John Doe' do
        @mails.length.should == 0
      end
    end
  end

  describe 'refusal' do
    before do
      @mails = @mailer.mail_communicate_refusal
    end
    
    it 'should inform John Doe that pub session is not scheduled' do
      @mails.length.should == 1
      mail = @mails[0]
      mail.from.should == ['orga@conf.agile-france.org']
      mail.to.should == [@speaker.email]
      mail.subject.should == 'les sessions suivantes ne sont pas retenues'
      mail.body.raw_source.should == <<eos
Bonjour John Doe

les sessions suivantes ne sont pas retenues au programme
- pub

Nous vous remercions d'avoir proposé, car cela nous a permis de choisir
L'Organisation de la conférence Agile France
eos
    end

    it 'should send it' do
      Mail::TestMailer.deliveries.should == @mails
    end
  end

  describe 'communicate_session_is_rescheduled' do
    before do
      @diner.scheduled_at = DateTime.parse('31/05/2010 14h')
      @diner.save!
      date = Date.parse('06/06/2006')
      @lunch = Session.new(:title => 'lunch', :speaker => @speaker, :scheduled => true, :scheduled_at => date)
      @lunch.save!
      @mails = @mailer.communicate_session_is_rescheduled @diner
    end

    it 'should inform John Doe that pub session is not scheduled' do
      @mails.length.should == 1
      mail = @mails[0]
      mail.from.should == ['orga@conf.agile-france.org']
      mail.to.should == [@speaker.email]
      mail.subject.should == 'une de vos sessions a été reprogrammée'
      mail.body.raw_source.should == <<eos
Bonjour John Doe
Pour exploiter au mieux vos contraintes ou les capacités des salles, nous avons reprogrammé au moins une de vos session
Nous vous confirmons votre agenda
- diner, le 31/05/2010 à 14:00

- lunch, le 06/06/2006 à 00:00

L'Organisation de la conférence Agile France
eos
    end

    it 'should send it' do
      Mail::TestMailer.deliveries.should == @mails
    end
  end

  describe 'inject_locals' do
    it 'should make available hash values under hash keys' do
      mailer = Mailer.new
      mailer.inject_locals({:foo => 'foo'}).should == mailer
      mailer.foo.should == 'foo'
    end
  end
end