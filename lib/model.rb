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

  belongs_to :speaker

  def duration
    180
  end

  class Category
    BWORKSHOP = 'BWORKSHOP'
    KEYNOTE = 'KEYNOTE'
    OTHER = 'OTHER'
    REX = 'REX'
    TALK = 'TALK'
    WORKSHOP = 'WORKSHOP'

    def all
      [BWORKSHOP, KEYNOTE, OTHER, REX, TALK, WORKSHOP]
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