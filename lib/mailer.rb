#encoding: utf-8
require 'mail'
require 'model'
require 'renderable'
require 'logger'

class Mailer
  @@logger = Logger.new('mailer.log')
  @@mail_logger = Logger.new('mails.log')
  include Renderable

  def mail_scheduled_sessions(speakers, subject, template)
    mails = []
    speakers.each do |speaker|
      mails << mail(speaker, subject, template)
    end
    mails
  end

  def mail_speaker_having_at_least_one_scheduled_session
    subject = 'vous avez une session retenue au programme de la conférence Agile France'
    template = 'session_is_accepted.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled => true})

    mail_scheduled_sessions(speakers, subject, template)
  end

  def mail_confirm_schedule_time_to_speaker
    subject = 'heure de vos sessions à la conférence Agile France'
    template = 'session_is_scheduled_at.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled => true})

    mail_scheduled_sessions(speakers, subject, template)
  end

  def mail_ask_for_capacity
    subject = 'nombre de participants que vous pouvez accueillir'
    template = 'ask_for_capacity.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled => true, :capacity => nil})

    mail_scheduled_sessions(speakers, subject, template)    
  end

  def mail_communicate_refusal
    subject = 'les sessions suivantes ne sont pas retenues'
    template = 'communicate_refusal.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled => false})

    mail_scheduled_sessions(speakers, subject, template)
  end

  def communicate_session_is_rescheduled(session)
    subject = 'votre session a été reprogrammée'
    template = 'communicate_session_is_rescheduled.text.erb'
    speakers = Speaker.all(:sessions => {:scheduled => false})

    mail_scheduled_sessions(speakers, subject, template)
  end

  def mail(speaker, subject, template)
    erb = ERB.new(read_template(template))
    content = erb.result binding
    mail = Mail.new do
      content_type 'text/html; charset=UTF-8'
      from 'orga@conf.agile-france.org'
      to "#{speaker.email}"
      subject(subject)
      body content
    end
    scheduled_sessions = []
    speaker.scheduled_sessions.each {|session| scheduled_sessions << session.title}
    @@logger.info "sending to #{speaker.email} : #{scheduled_sessions} template #{template}"
    @@mail_logger.info "#{mail} => #{mail.body}"
    mail.deliver!
  end

  def inject_locals(hash)
    self
  end
end