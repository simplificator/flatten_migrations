# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flatten_migrations/version"

Gem::Specification.new do |s|
  s.name        = "flatten_migrations"
  s.version     = FlattenMigrations::VERSION
  s.authors     = ["Krzysztof Sakwerda"]
  s.email       = ["ksakwerda@gmail.com"]
  s.homepage    = "https://github.com/simplificator/flatten_migrations"
  s.summary     = "Migration flattener for rails applications"
  s.description = "Adds rake db:flatten_migrations task which deletes existing migrations and generates initial one directly from schema.rb file."

  s.rubyforge_project = "flatten_migrations"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rake"
  s.add_dependency "rails", ">= 3.0"  
end
