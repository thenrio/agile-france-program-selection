require File.expand_path(File.dirname(__FILE__) + '/../../config/boot')
require 'model/program'

('A'..'G').each do |name|
  Room.create(:name => name) unless Room.first(:name => name)
end


