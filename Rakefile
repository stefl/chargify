require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jsmestad-chargify"
    gem.summary = %Q{Ruby wrapper for the Chargify API}
    gem.email = "justin.smestad@gmail.com"
    gem.homepage = "http://github.com/jsmestad/chargify"
    gem.authors = ["Wynn Netherland", "Justin Smestad"]

    gem.add_dependency('httparty', '~> 0.6.1')
    gem.add_dependency('hashie', '~> 0.1.8')
    gem.add_dependency('json')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

desc "Run all examples using rcov"
RSpec::Core::RakeTask.new :rcov => :cleanup_rcov_files do |t|
  t.rcov = true
  t.rcov_opts =  %[-Ilib -Ispec --exclude "mocks,expectations,gems/*,spec/resources,spec/lib,spec/spec_helper.rb,db/*,/Library/Ruby/*,config/*"]
  t.rcov_opts << %[--no-html --aggregate coverage.data]
end

task :default => :spec

