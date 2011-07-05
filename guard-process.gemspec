# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/process/version"

Gem::Specification.new do |s|
  s.name        = "guard-process"
  s.version     = Guard::Process::VERSION
  s.authors     = ["Mark Kremer"]
  s.email       = ["mark@socialreferral.com"]
  s.homepage    = ""
  s.summary     = %q{Guard extension to run cli processes}
  s.description = %q{Guard extension to run cli processes}

  s.rubyforge_project = "guard-process"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('guard', '>= 0.4.2')
end
