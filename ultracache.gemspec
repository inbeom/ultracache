# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require "ultracache/version"

Gem::Specification.new do |s|
  s.name        = "ultracache"
  s.version     = Ultracache::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Inbeom Hwang"]
  s.email       = ["inbeom@wafflestudio.com"]
  s.homepage    = "http://github.com/inbeom/ultracache"
  s.summary     = "Model-level cache for dynamic attributes"
  s.description = "Ultracache reduces cost needed by dynamic attribute computation by caching them into Redis"

  s.add_dependency("activemodel", ["~> 3.0"])
  s.add_dependency("activesupport", ["~> 3.0"])
  s.add_dependency("redis", ["~> 2.2"])
  s.add_dependency("json")

  s.add_development_dependency("rspec", ["~> 2.6"])
  s.add_development_dependency("mocha")
  s.add_development_dependency("bson_ext")
  s.add_development_dependency("mongoid")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
