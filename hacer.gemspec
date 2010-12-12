# Make sure we get the gli that's local
require File.join([File.dirname(__FILE__),'lib','hacer_version.rb'])

spec = Gem::Specification.new do |s| 
  s.name = 'hacer'
  s.version = Hacer::VERSION
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://davetron5000.github.com/hacer'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A very simple todo list API'
  s.description = 'This is an extremely simple API for creating and managing todo lists.  The todo list is a simple YAML file that stores a list of todo items that can be completed/checked off'
  s.files = %w(
    lib/hacer.rb
    lib/hacer_version.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options << '--title' << 'Hacer, the simple todo list API' << '--main' << 'README.rdoc' << '-R'
  s.rubyforge_project = 'hacer'
end

