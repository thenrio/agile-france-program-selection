#encoding: utf-8
require 'mail'
require 'model'
require 'renderable'

class Mailer
  include Renderable
  def mail_speaker_having_at_least_one_scheduled_session
    speakers = Speaker.all(:sessions => {:scheduled => true})
    mails = []
    speakers.each do |speaker|
      mails << mail(speaker, speaker.sessions)
    end
    mails
  end

  def mail(speaker, sessions)
    mail = Mail.new do
      from 'orga@conf.agile-france.org'
      to "#{speaker.email}"
      subject 'vous avez une session retenue au programme de la conférence Agile France'
    end
    mail
  end
end