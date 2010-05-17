$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../lib'))
require 'configuration'
$database_configuration ||= Configuration.new :path => '/Users/thenrio/src/ruby/agile-france-database/prod.db'