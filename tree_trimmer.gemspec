# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tree_trimmer/version'

Gem::Specification.new do |spec|
  spec.name          = "tree_trimmer"
  spec.version       = TreeTrimmer::VERSION
  spec.authors       = ["David Begin"]
  spec.email         = ["davidmichaelbe@gmail.com"]

  spec.summary       = %q{A command line tool to clean up git branches}
  spec.description   = %q{A command line tool to make it easier to clean up all your old git branches.}
  spec.homepage      = "https://github.com/presidentJFK/tree_trimmer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["tree_trimmer"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "downup", "0.11.6"
  spec.add_runtime_dependency "colorize"
end
