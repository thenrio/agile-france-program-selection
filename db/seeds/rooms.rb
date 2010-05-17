$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'
require 'model/program'
('A'..'G').each do |name|
  Room.create(:name => name) unless Room.first(:name => name)
end


