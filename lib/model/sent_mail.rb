require 'dm-core'

class SentMail
  include DataMapper::Resource

  property :id, Serial
  property :class, String
  property :person_id, Integer
  property :template, String
end