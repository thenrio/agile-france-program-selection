require 'dm-core'
require 'model/full_named'

class Session
  include DataMapper::Resource
  storage_names[:default] = 'talk_proposal'

  property :id, Serial, :field => 'talk_id'
  property :theme, String
  property :category, String
  property :level, String
  property :age, String
  property :title, String
  property :key, String
  property :vote, Float, :default => 0
  property :scheduled_at, DateTime
  property :capacity, Integer

  belongs_to :speaker
  belongs_to :room, :required => false


  def duration
    Category.duration(self.category)
  end

  @@level_to_shuhari = {
      'ADVANCED' => 'ri',
      'INTERMEDIATE' => 'ha',
      'BEGINNER' => 'shu',
  }
  
  def shuhari
    s = @@level_to_shuhari[self.level]
    return s if s
    ''
  end

  class Category
    BWORKSHOP = 'BWORKSHOP'
    KEYNOTE = 'KEYNOTE'
    OTHER = 'OTHER'
    REX = 'REX'
    TALK = 'TALK'
    WORKSHOP = 'WORKSHOP'

    def self.all
      categories = [BWORKSHOP, KEYNOTE, OTHER, REX, TALK, WORKSHOP]
      if block_given?
        categories.each {|c| yield c}
      end
      categories
    end

    @@category_to_duration = {
      BWORKSHOP => 180,
      KEYNOTE => 60,
      OTHER => 60,
      REX => 30,
      TALK => 60,
      WORKSHOP => 120    
    }
    def self.duration(category)
      return @@category_to_duration[category] if @@category_to_duration[category]
      60
    end
  end
end

class Speaker
  include DataMapper::Resource
  include FullNamed
  storage_names[:default] = 'talk_speaker'

  property :id, Serial, :field => 'speaker_id'
  property :firstname, String
  property :lastname, String
  property :email, String


  has n, :sessions

  def scheduled_sessions
    sessions.all(:scheduled_at.not => nil)
  end

  def unscheduled_sessions
    sessions.all(:scheduled_at => nil)
  end

  def self.scheduled
    Speaker.all(:sessions => {:scheduled_at.not => nil})
  end

  def self.unscheduled
    Speaker.all(:sessions => {:scheduled_at => nil})
  end
end

class Room
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :capacity, Integer

  has n, :sessions
end