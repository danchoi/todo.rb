# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'todo'

Gem::Specification.new do |s|
  s.name        = "todo"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.0'

  s.authors     = ["Daniel Choi"]
  s.email       = ["dhchoi@gmail.com"]
  s.homepage    = "http://github.com/danchoi/gitfinger"
  s.summary     = %q{Finger GitHub users}
  s.description = %q{Finger GitHub users}

  s.rubyforge_project = "gitfinger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'highline', '>= 1.6.11'
end
