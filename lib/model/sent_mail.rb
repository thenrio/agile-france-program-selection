require 'dm-core'
require 'forwardable'

class SentMail
  include DataMapper::Resource

  property :id, Serial
  property :class, String
  property :person_id, Integer
  property :template, String
end