$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'
path = File.expand_path(File.dirname(__FILE__) + '/../../../agile-france-database')
$database_configuration ||= Configuration.new :path => "#{path}/prod.db"