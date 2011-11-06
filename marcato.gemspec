require File.expand_path('marcato', File.dirname(__FILE__)) 
 
Gem::Specification.new do |s|
  s.name        = 'marcato'
  s.version     = Marcato::VERSION
  s.platform    = Gem::Platform::CURRENT
  s.authors     = ['Hugh Bien']
  s.email       = ['hugh@hughbien.com']
  s.homepage    = 'https://github.com/hughbien/marcato'
  s.summary     = 'Lightweight command line music player for iTunes'
  s.description = 'Marcato is a command line music player that works with ' +
                  'your iTunes playlists.  Currently only for OS X.'
 
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency 'plist'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
 
  s.files        = Dir.glob('*.{rb,md}') + %w(marcato)
  s.bindir       = '.'
  s.executables  = ['marcato']
end
