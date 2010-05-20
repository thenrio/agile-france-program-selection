#encoding: utf-8
require 'mail'
require 'model/program'
require 'renderer'
require 'logger'

class Mailer
  @@logger = Logger.new('mailer.log')
  @@mail_logger = Logger.new('mails.log')

  def mail_speakers(speakers, subject, template)
    mails = []
    speakers.each do |speaker|
      mails << mail(speaker, subject, template)
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

  def mail_invoice(invoice, template)
    
  end

  def communicate_session_is_rescheduled(session)
    subject = 'une de vos sessions a été reprogrammée'
    template = 'communicate_session_is_rescheduled.text.erb'
    speakers = Speaker.scheduled

    mail_speakers(speakers, subject, template)
  end

  def make_body(speaker, template, locals={})
    renderer = Renderer::Erb.new
    renderer.render(template, locals.merge(:speaker => speaker))
  end

  def mail(speaker, subject, template, locals={})
    body = make_body(speaker, template, locals)
    mail = Mail.new do
      content_type 'text/html; charset=UTF-8'
      from 'orga@conf.agile-france.org'
      to "#{speaker.email}"
      subject(subject)
      body(body)
    end
    @@logger.info "sending to #{speaker.email} template #{template}"
    @@mail_logger.info "#{mail} => #{mail.body}"
    mail.deliver!
  end
end