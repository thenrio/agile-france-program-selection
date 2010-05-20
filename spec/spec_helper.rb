require 'spec'
require 'spec/autorun'
require 'ruby-debug'

Spec::Runner.configure do |config|
  config.mock_with :rr
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'config'))
ENV['AGILE_FRANCE_ENV'] = 'test'  
require 'boot'

def empty_database
  require 'configuration'
  Configuration.new.test
end