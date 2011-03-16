#encoding: utf-8
require 'rake'

task :env do
  require File.expand_path(File.dirname(__FILE__) + '/config/boot')
  Dir.glob("lib/model/*.rb") do |file|
    require file
  end
end

# db
namespace :db do
  task :migrate => [:env] do
    require 'dm-migrations/migration_runner'
    desc 'run pending migrations'
    Dir.glob("db/migrations/*.rb") do |migration|
      load migration
      migrate_up!
    end
  end

  namespace :sow do
    desc 'seed rooms'
    task :rooms => [:env] do
      ruby 'db/seeds/rooms.rb'
    end
    desc 'seed from csv file'
    task :csv => [:rooms] do
      ruby 'db/seeds/csv.rb'
    end
    desc 'seed redeemable coupon'
    task :redeemable_coupon => [:csv] do
      ruby 'db/seeds/redeemable_coupon.rb'
    end
    task :all => [:csv, :redeemable_coupon]
  end

  namespace :list do
    desc 'list all attendees in an html format'
    task :attendees => [:env] do
      require 'renderer'
      attendees = Attendee.all.to_a.sort {|a,b| a.full_name.strip <=> b.full_name.strip}
      renderer = Renderer::Hml.new
      renderer.render('attendees.html.haml', :attendees => attendees) do |content|
        renderer.write(content, 'attendees.html')  
      end
    end
  end
end

namespace :mail do
  desc 'send confirmation mail to attendees'
  namespace :confirm do
    task :attendee => [:env] do
      require 'mailer'
      mailer = Mailer.new
      Attendee.all.each do |attendee|
        mailer.confirm_attendee(attendee)
      end
      mailer.deliver!
    end
  end

  desc 'send mail to speaker : propose to agile-france-2011 ?'
  task :'2011' => [:env] do
    require 'mailer'
    mailer = Mailer.new
    subject = 'Proposer une session pour la Conférence Agile France 2011 ?'
    template = 'ask_speaker_for_feedback.html.haml'
    Speaker.all.each do |speaker|
      m = mailer.mail(speaker, subject, template, :speaker => speaker)
      puts m
    end
  end

  namespace :ask_for_feedback do
    desc 'send mail to attendees : what is your feedback ?'
    task :attendee => [:env] do
      require 'mailer'
      mailer = Mailer.new
      subject = 'Comment s\'est passé la conférence Agile France ?'
      template = 'ask_attendee_for_feedback.html.haml'
      Attendee.all.each do |attendee|
        mailer.mail(attendee, subject, template, :attendee => attendee)
      end
      mailer.deliver!
      end

    desc 'send mail to scheduled speakers : what is your feedback ?'
    task :speaker => [:env] do
      require 'mailer'
      mailer = Mailer.new
      subject = 'Comment s\'est passé votre session à la conférence Agile France ?'
      template = 'ask_speaker_for_feedback.html.haml'
      Speaker.scheduled.each do |speaker|
        m = mailer.mail(speaker, subject, template, :speaker => speaker)
      end
      puts m
      mailer.deliver!
    end   
  end
end
