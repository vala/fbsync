$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fbsync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fbsync"
  s.version     = Fbsync::VERSION
  s.authors     = ["Valentin Ballestrino"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://glyph.fr"
  s.summary     = "Fbsync allows to easily write sync tasks between an app and a master facebook account"
  s.description = "Fbsync allows to easily write sync tasks between an app and a master facebook account"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency "fb_graph"

  s.add_development_dependency "sqlite3"
end
