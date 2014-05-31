# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth/ok/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth-ok"
  spec.version       = Oauth::Ok::VERSION
  spec.authors       = ["DISTROID"]
  spec.email         = ["diserve.it@gmail.com"]
  spec.description   = %q{Auth from Odnoklassniki.ru}
  spec.summary       = %q{Auth from Odnoklassniki.ru}
  spec.homepage      = "https://github.com/distroid/OkAuth-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
