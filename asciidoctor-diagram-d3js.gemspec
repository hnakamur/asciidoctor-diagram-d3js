# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciidoctor-diagram-d3js/version'

Gem::Specification.new do |spec|
  spec.name          = "asciidoctor-diagram-d3js"
  spec.version       = Asciidoctor::Diagram::D3js::VERSION
  spec.authors       = ["Hiroaki Nakamura"]
  spec.email         = ["hnakamur@gmail.com"]
  spec.summary       = %q{an extension to asciidoctor-diagram to include D3.js diagrams}
  spec.description   = "This extension open html files using D3.js with Phantom.js, convert them to png or svg files, and include them in asciidoc documents."
  spec.homepage      = "https://github.com/hnakamur/asciidoctor-diagram-d3js"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "nokogiri", "~> 1.5.10"
end
