require "asciidoctor-diagram-d3js/version"
require 'asciidoctor/extensions'

Asciidoctor::Extensions.register do
  require_relative 'asciidoctor-diagram-d3js/extension'
  block Asciidoctor::Diagram::D3jsBlockProcessor, :d3js
  block_macro Asciidoctor::Diagram::D3jsBlockMacroProcessor, :d3js
end
