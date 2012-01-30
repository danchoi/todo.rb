# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'todo'

Gem::Specification.new do |s|
  s.name        = "todo.rb"
  s.version     = "0.0.4"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.0'

  s.authors     = ["Daniel Choi"]
  s.email       = ["dhchoi@gmail.com"]
  s.homepage    = "http://danchoi.github.com/todo.rb/"
  s.summary     = %q{Finger GitHub users}
  s.description = %q{Finger GitHub users}

  s.rubyforge_project = "todo.rb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'highline', '>= 1.6.11'
  s.add_dependency 'color-tools', '~> 1.3'
end
