# $Id$
$:.push 'lib'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rdoc/task'
require 'fileutils'
require 'typelib'

include FileUtils::Verbose

task :default => [ :test, :dist ]

task :fixperms do
    chmod(0755, Dir['bin/*'])  
end

#
# Tests
#

Rake::TestTask.new do |t|
    t.libs << 'lib'
    t.test_files = FileList['test/test*.rb']
    t.verbose = true 
end

#
# Distribution
#

task :dist      => [:fixperms, :repackage, :gem, :rdoc]
task :distclean => [:clobber_package, :clobber_rdoc]
task :clean     => [:distclean]

#
# Documentation
#

RDoc::Task.new do |rd|
    rd.rdoc_dir = "rdoc"
    rd.main = "README.rdoc"
    rd.rdoc_files.include("README.rdoc")
    rd.rdoc_files.include("./lib/**/*.rb")
    rd.options = %w(-a)
end

#
# Packaging
# 

spec = Gem::Specification.new do |s|
    s.name = "typelib"
    s.version = TypeLib::VERSION
    s.author = "Erik Hollensbe"
    s.email = "erik@hollensbe.org"
    s.summary = "An on-demand arbitrary check and conversion library that won't destroy your data."

    s.files = Dir["Rakefile"] + Dir["README"] + Dir["lib/**/*"] + Dir['test/**/*']

    s.has_rdoc = true
end

Rake::GemPackageTask.new(spec) do |s|
end

Rake::PackageTask.new(spec.name, spec.version) do |p|
    p.need_tar_gz = true
    p.need_zip = true
    p.package_files.include("./bin/**/*")
    p.package_files.include("./Rakefile")
    p.package_files.include("./lib/**/*.rb")
    p.package_files.include("README")
end
