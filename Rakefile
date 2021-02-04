require "bundler/gem_tasks"
require "rdoc/task"
require "rspec/core/rake_task"

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

task :doc => :rdoc
task :test => :spec
task :default => :spec
