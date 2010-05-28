#!/usr/bin/env ruby
require 'ruby-debug'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

ENV['AGILE_FRANCE_ENV'] ||= 'test'
Dir.glob "#{File.expand_path(File.dirname(__FILE__))}/#{ENV['AGILE_FRANCE_ENV']}/*.rb" do |file|
  load file
end
