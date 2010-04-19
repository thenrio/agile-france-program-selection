require 'mail'
require 'model'

class Mailer
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
    end
    mail
  end
end