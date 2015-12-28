# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "diamond-lang"
  gem.homepage = "http://bensites.com/diamond-lang/"
  gem.license = "MIT"
  gem.summary = "A Ruby Framework for creating Minecraft 1 Command Creations."
  gem.description = "Making Minecraft 1 Command Creations with ruby. It's as easy as `c.say 123`"
  gem.email = "ben@bensites.com"
  gem.authors = ["Ben (@penne12_)"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = '--format documentation'
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:webspec) do |spec|
  spec.rspec_opts = '--format html --out spec/index.html'
  spec.pattern = FileList['spec/**/*_spec.rb']
  `open spec/index.html`
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "diamond-lang #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
