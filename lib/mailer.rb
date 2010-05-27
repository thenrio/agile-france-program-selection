#encoding: utf-8
require 'mail'
require 'model/program'
require 'renderer'
require 'logger'


class MessageToPerson < Mail::Message
  attr_accessor :person, :template

  def deliver
    Mailer.logger.info "#{self} using template #{template}=> #{body}"
    super
  end
end


class Mailer
  def self.logger=(logger)
    @@logger=logger
  end
  def self.logger
    @@logger ||= Logger.new("mailer-#{Date.today}.log")
  end
  def logger
    Mailer.logger
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

  def mail(speaker, subject, template, locals)
    body = make_body(template, locals)
    mail = MessageToPerson.new do
      content_type 'text/html; charset=UTF-8'
      from 'orga@conf.agile-france.org'
      to "#{speaker.email}"
      subject(subject)
      body(body)
    end
    mail.deliver
  end

  def confirm_attendee(attendee)
    subject = 'comment vous rendre à la conférence Agile France'
    template = 'confirm_attendee.html.haml'
    mail(attendee, subject, template, :attendee => attendee)
  end
end