$:.push File.expand_path('../lib', __FILE__)
require 'wookie_connector/version'

Gem::Specification.new do |s|
  s.name = 'wookie_connector'
  s.version = WookieConnector::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Ryan Ahearn']
  s.email = ['ryan@coshx.com']
  s.summary = 'Ruby connector for embedding widgets served from Apache Wookie'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename f }
  s.require_paths = ['lib']
end
