require 'dm-core'

class SentMail
  include DataMapper::Resource

  property :id, Serial
  property :person_class, String
  property :person_id, Integer
  property :template, String

  def person
    Company.get person_id
  end
end