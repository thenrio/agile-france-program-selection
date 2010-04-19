$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'configuration'
require 'model'
require 'mailer'

Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-program-selection/prod.db'

# and what about some rake task ?
# will look better...



