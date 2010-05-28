require 'configuration'
path = '/Users/thenrio/src/python/xpdayfr'
$database_configuration ||= Configuration.new :path => "#{path}/prod.db"