require 'json'
require 'time'
require 'nokogiri'
require 'asciidoctor-diagram/extensions'

module Asciidoctor
  module Diagram
    # @private
    module D3js
      HTML2PNG_PATH = File.expand_path 'html2png.js', File.dirname(__FILE__)
      HTML2SVG_PATH = File.expand_path 'html2svg.js', File.dirname(__FILE__)

      def d3js_to_png(parent, source)
        find_phantomjs parent

        # NOTE: target_file extension must be '.png' for phantomjs to create png files
        target_file = Tempfile.new(['phantomjs', '.png'])
        begin
          target_file.close

          args = [HTML2PNG_PATH, source.file_name, target_file.path]
          system @phantomjs, *args
          result_code = $?

          raise "#{@phantomjs} image generation failed" unless result_code == 0

          File.read(target_file.path)
        ensure
          target_file.unlink
        end
      end

      def d3js_to_svg(parent, source)
        find_phantomjs parent

        args = [@phantomjs, HTML2SVG_PATH, source.file_name]
        content = IO.popen(args, "r+") do |io|
          io.close_write
          io.read
        end

        doc = Nokogiri::XML(content)
        doc.encoding = 'UTF-8'
        root = doc.root()
        root.add_namespace(nil, 'http://www.w3.org/2000/svg')
        root.add_namespace('xlink', 'http://www.w3.org/1999/xlink')
        doc.to_xml
      end

      private def find_phantomjs(parent)
        unless @phantomjs
          @phantomjs = parent.document.attributes['phantomjs']
          @phantomjs = ::Asciidoctor::Diagram.which('phantomjs') unless @phantomjs && File.executable?(@phantomjs)
          raise "Could not find the Phantom.js 'phantomjs' executable in PATH; add it to the PATH or specify its location using the 'phantomjs' document attribute" unless @phantomjs
        end
      end

      def self.included(mod)
        mod.register_format(:png, :image) do |c, p|
          d3js_to_png p, c
        end
        mod.register_format(:svg, :image) do |c, p|
          d3js_to_svg p, c
        end
      end

      class Source < Extensions::FileSource
        attr_accessor :file_name
      end
    end

    class D3jsBlockProcessor < Extensions::DiagramBlockProcessor
      include D3js

      def create_source(parent, reader, attributes)
        D3js::Source.new(reader.read.strip, attributes)
      end
    end

    class D3jsBlockMacroProcessor < Extensions::DiagramBlockMacroProcessor
      include D3js

      def create_source(parent, target, attributes)
        D3js::Source.new("#{target.strip}.html", attributes)
      end
    end
  end
end
