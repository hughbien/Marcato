require File.expand_path('marcato', File.join(File.dirname(__FILE__), 'lib'))

task :default => :spec

task :spec do
  ruby 'spec/*_spec.rb' # see .watchr for continuous testing
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
