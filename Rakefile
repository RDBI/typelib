require 'rubygems'
require 'rake'

version = (File.exist?('VERSION') ? File.read('VERSION') : "").chomp

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "typelib"
    gem.authors = ["Erik Hollensbe"]
    gem.email = "erik@hollensbe.org"
    gem.summary = "An on-demand arbitrary check and conversion library that won't destroy your data."
    gem.homepage = "http://github.com/RDBI/typelib"
    gem.authors = ["Erik Hollensbe"]

    gem.add_development_dependency 'test-unit'
    gem.add_development_dependency 'rdoc'

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  gem 'test-unit'
  require 'rake/testtask'
  Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :test do
    abort "test-unit gem is not available. In order to run test-unit, you must: sudo gem install test-unit"
  end
end


begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :test

begin
  require 'rdoc/task'
  RDoc::Task.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""

    rdoc.main = 'README.rdoc'
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "RDBI #{version} Documentation"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError => e
  rdoc_missing = lambda do
    # no-op
  end
  task :rdoc, &rdoc_missing
  task :clobber_rdoc, &rdoc_missing
end

task :to_blog => [:clobber_rdoc, :rdoc] do
  sh "rm -fr $git/blog/content/docs/typelib && mv doc $git/blog/content/docs/typelib"
end

task :install => [:test, :build]

task :docview => [:rerdoc] do
  sh "open rdoc/index.html"
end

# vim: syntax=ruby ts=2 et sw=2 sts=2
