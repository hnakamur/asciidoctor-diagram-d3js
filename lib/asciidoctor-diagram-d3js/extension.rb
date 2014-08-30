require 'json'
require 'time'
require 'asciidoctor-diagram/api/diagram'

module Asciidoctor
  module Diagram
    # @private
    module D3js
      private

      HTML2PNG_PATH = File.expand_path File.join('..', 'html2png'), File.dirname(__FILE__)
      HTML2SVG_PATH = File.expand_path File.join('..', 'html2svg'), File.dirname(__FILE__)

      def self.d3js_to_png(source, target)
        unless @phamtomjs
          @phamtomjs = parent.document.attributes['phantomjs']
          @phamtomjs = ::Asciidoctor::Diagram.which('phantomjs') unless @phamtomjs && File.executable?(@phamtomjs)
          raise "Could not find the Phantom.js 'phantomjs' executable in PATH; add it to the PATH or specify its location using the 'phantomjs' document attribute" unless @phamtomjs
        end
      end

      def self.d3js_to_svg(source, target)
        unless @phamtomjs
          @phamtomjs = parent.document.attributes['node']
          @phamtomjs = ::Asciidoctor::Diagram.which('node') unless @phamtomjs && File.executable?(@phamtomjs)
          raise "Could not find the Node.js 'node' executable in PATH; add it to the PATH or specify its location using the 'node' document attribute" unless @phamtomjs
        end
      end

      def self.included(mod)
        mod.register_format(:png, :image) do |c, p|
puts "included c=#{c}, p=#{p}"
          d3js_to_png c, p
        end
        mod.register_format(:svg, :image) do |c, p|
puts "included c=#{c}, p=#{p}"
          d3js_to_svg c, p
        end
      end
    end

    class D3jsBlockProcessor < API::DiagramBlockProcessor
      include D3js
    end

    class D3jsBlockMacroProcessor < API::DiagramBlockMacroProcessor
      include D3js
    end
  end
end
