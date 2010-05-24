$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'
path = '/Users/thenrio/src/python/xpdayfr'
$database_configuration ||= Configuration.new :path => "#{path}/prod.db"