require File.expand_path('marcato', File.dirname(__FILE__))

task :default => :test

task :test do
  ruby '*_test.rb' # see .watchr for continuous testing
end

task :build do
  `gem build marcato.gemspec`
end

task :clean do
  rm Dir.glob('*.gem')
end

task :push => :build do
  `gem push marcato-#{Marcato::VERSION}.gem`
end
