require 'dm-core'

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
  property :vote, Integer

  belongs_to :speaker

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
  storage_names[:default] = 'talk_speaker'

  property :id, Serial, :field => 'speaker_id'
  property :firstname, String
  property :lastname, String


  has n, :sessions

  def full_name
    "#{firstname} #{lastname}"
  end
end