require 'rake'
require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jsmestad-chargify"
    gem.summary = %Q{Ruby wrapper for the Chargify API}
    gem.email = "justin.smestad@gmail.com"
    gem.homepage = "http://github.com/jsmestad/chargify"
    gem.authors = ["Wynn Netherland", "Justin Smestad"]

    bundle = Bundler::Definition.from_gemfile('Gemfile')
    bundle.dependencies.each do |dep|
      next unless dep.groups.include?(:runtime)
      gem.add_dependency(dep.name, dep.requirement.to_s)
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

