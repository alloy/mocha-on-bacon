Gem::Specification.new do |s|
  s.name        = 'mocha-on-bacon'
  s.version     = '0.2.2'
  s.date        = Date.today
  s.homepage    = 'https://github.com/alloy/mocha-on-bacon'

  s.summary     = 'A Mocha adapter for Bacon'
  s.description = "A Mocha adapter for Bacon, because it's yummy!"

  s.authors     = ['Eloy Duran']
  s.email       = 'eloy.de.enige@gmail.com'

  s.require_paths    = %w{ lib }
  s.files            = %w{ LICENSE README.md lib/mocha-on-bacon.rb }
  s.extra_rdoc_files = %w{ LICENSE README.md }
  s.rdoc_options     = %w{ --charset=UTF-8 }

  s.add_runtime_dependency('mocha', '>= 0.13.0')

  s.rubygems_version = '1.3.7'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
end

