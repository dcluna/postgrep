# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "postgrep/version"

Gem::Specification.new do |s|
  s.name        = "postgrep"
  s.version     = Postgrep::VERSION
  s.authors     = ["Daniel Luna"]
  s.email       = ["dancluna@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Enables full text search for DataMapper w/ Postgres}
  s.description = %q{Enables full text search for DataMapper w/ Postgres}

  s.rubyforge_project = "postgrep"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "dm-core"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_runtime_dependency "dm-core"
  s.add_runtime_dependency "dm-migrations"
  s.add_runtime_dependency "dm-postgres-adapter"
end
