#encoding: utf-8
require 'model/program'
require 'renderer'
require 'logger'
require 'model/sent_mail'

require 'mail'
module Mail
  class Message
    def person(person=nil)
      if person
        @person=person
        self
      else
        @person
      end
    end

    def template(template=nil)
      return @template unless template
      @template=template
      self
    end

    alias_method :raw_deliver, :deliver

    def deliver_with_logging
      Mailer.logger.info "send to #{@person.email} with template #{@template} => #{@body}"
      raw_deliver
    end

    def deliver
      if person
        hash = {:person_class => @person.class.to_s.to_sym, :person_id => person.id, :template => @template}
        mail = SentMail.first(hash)
        unless mail
          Mailer.logger.info "send to #{@person.email} with template #{@template} => #{@body}"
          raw_deliver
          SentMail.create(hash)
        end
      else
        raw_deliver
      end
    end
  end
end


class Mailer
  def self.logger=(logger)
    @@logger=logger
  end

  def self.logger
    @@logger ||= Logger.new("mailer-#{Date.today}.log")
  end

  def mail_speakers(speakers, subject, template)
    mails = []
    speakers.each do |speaker|
      mails << mail(speaker, subject, template, :speaker => speaker)
    end
    mails
  end

  def mail_speaker_having_at_least_one_scheduled_session
    subject = 'vous avez une session retenue au programme de la conférence Agile France'
    template = 'session_is_accepted.text.erb'
    speakers = Speaker.scheduled

    mail_speakers(speakers, subject, template)
  end

  def mail_confirm_schedule_time_to_speaker
    subject = 'heure de vos sessions à la conférence Agile France'
    template = 'session_is_scheduled_at.text.erb'
    speakers = Speaker.scheduled

    mail_speakers(speakers, subject, template)
  end

  def mail_ask_for_capacity
    subject = 'nombre de participants que vous pouvez accueillir'
    template = 'ask_for_capacity.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled_at.not => nil, :capacity => nil})

    mail_speakers(speakers, subject, template)
  end

  def mail_communicate_refusal
    subject = 'les sessions suivantes ne sont pas retenues'
    template = 'communicate_refusal.text.erb'
    speakers = Speaker.unscheduled

    mail_speakers(speakers, subject, template)
  end

  def create_renderer_for(template)
    if File.extname(template) == '.haml'
      Renderer::Hml.new
    else
      Renderer::Erb.new
    end
  end

  private :create_renderer_for

  def make_body(template, locals)
    create_renderer_for(template).render(template, locals)
  end

  def mail(person, subject, template, locals={})
    body = make_body(template, locals)
    message = Mail.new do
      content_type 'text/html; charset=UTF-8'
      from 'orga@conf.agile-france.org'
      to "#{person.email}"
      subject(subject)
      person(person)
      template(template)
      body(body)
    end
    inbox << message
    message
  end

  def inbox
    @inbox ||= []
  end

  def deliver!
    while not inbox.empty?
      message = inbox.pop
      begin
        message.deliver
      rescue => failure
        Mailer.logger.error("failed to deliver #{message}, #{failure}")
      end
    end
  end

  def confirm_attendee(attendee)
    subject = 'comment vous rendre à la conférence Agile France'
    template = 'confirm_attendee.html.haml'
    mail(attendee, subject, template, :attendee => attendee)
  end
end