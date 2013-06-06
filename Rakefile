require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


task :default => :test

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
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "barmcakes"
  gem.homepage = "http://github.com/danmaclean/barmcakes"
  gem.license = "MIT"
  gem.summary = %Q{Miscellenitudinal tools and hack classes}
  gem.description = %Q{Just really stuff that I cobbled together that I use. You probably don't want this.}
  gem.email = "maclean.daniel@gmail.com"
  gem.authors = ["Dan MacLean"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new