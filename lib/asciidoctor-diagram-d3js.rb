require "asciidoctor-diagram-d3js/version"
require 'asciidoctor/extensions'

Asciidoctor::Extensions.register do
  require_relative 'asciidoctor-diagram-d3js/extension'
  block Asciidoctor::Diagram::CacooBlockProcessor, :d3js
  block_macro Asciidoctor::Diagram::CacooBlockMacroProcessor, :d3js
end
