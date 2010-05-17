require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "agile-france-program-selection"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "thierry.henrio@gmail.com"
    gem.homepage = "http://github.com/thierryhenrio/agile-france-program-selection"
    gem.authors = ["thierry"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.rcov = true
  spec.rcov_opts = ['--no-rcovrt'] # rt coverage is broken with ruby-1.9.1-p376 and rcov-0.9.8
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "agile-france-program-selection #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


# bluff dies with 3.0.0 activesupport
gem 'activesupport', '=2.3.5'
require 'metric_fu'
MetricFu::Configuration.run do |config|
  #define which metrics you want to use
  config.metrics  = [:flog, :flay, :roodi, :rcov]
  config.graphs   = [:flog, :flay, :roodi, :rcov]
  config.flay     = { :dirs_to_flay => ['lib'],
                      :minimum_score => 100  }
  config.flog     = { :dirs_to_flog => ['lib']  }
  config.roodi    = { :dirs_to_roodi => ['lib'] }
  config.rcov     = { :test_files => ['spec/**/*_spec.rb'],
                      :rcov_opts => ["--sort coverage",
                                     "--no-html",
                                     "--text-coverage",
                                     "--no-color",
                                     "--profile",
                                     '--no-rcovrt', # rt coverage is broken with ruby-1.9.1-p376 and rcov-0.9.8
                                     "--exclude /gems/,/Library/,spec"]}
  config.graph_engine = :bluff
end

require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

# migrate
namespace :db do
  require 'dm-migrations/migration_runner'
  task :migrate do
    Dir.glob("db/migrations/*.rb") do |migration|
      load migration
      migrate_up!
    end
  end
end
