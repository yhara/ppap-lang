# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ppap/version'

Gem::Specification.new do |spec|
  spec.name          = "ppap"
  spec.version       = PPAP::VERSION
  spec.authors       = ["Yutaka HARA"]
  spec.email         = ["yutaka.hara+github@gmail.com"]

  spec.summary       = %q{Programming Language PPAP}
  spec.homepage      = "https://github.com/yhara/ppap-lang"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19.1"
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
