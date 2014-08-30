require 'json'
require 'time'
require 'nokogiri'
require 'asciidoctor-diagram/api/diagram'

module Asciidoctor
  module Diagram
    # @private
    module D3js
      HTML2PNG_PATH = File.expand_path 'html2png.js', File.dirname(__FILE__)
      HTML2SVG_PATH = File.expand_path 'html2svg.js', File.dirname(__FILE__)

      def d3js_to_png(parent, source_basename)
puts "d3js_to_png"
        unless @phantomjs
          @phantomjs = parent.document.attributes['phantomjs']
          @phantomjs = ::Asciidoctor::Diagram.which('phantomjs') unless @phantomjs && File.executable?(@phantomjs)
          raise "Could not find the Phantom.js 'phantomjs' executable in PATH; add it to the PATH or specify its location using the 'phantomjs' document attribute" unless @phantomjs
        end

        source_file = File.expand_path "#{source_basename}.html"
        # NOTE: target_file extension must be '.png' for phantomjs to create png files
        target_file = Tempfile.new(['phantomjs', '.png'])
        begin
          target_file.close

          args = [HTML2PNG_PATH, source_file, target_file.path]
          system @phantomjs, *args
          result_code = $?

          raise "#{@phantomjs} image generation failed" unless result_code == 0

          File.read(target_file.path)
        ensure
          target_file.unlink
        end
      end

      def d3js_to_svg(parent, source_basename)
puts "d3js_to_svg parent.document.attributes=#{parent.document.attributes}"
        unless @phantomjs
          @phantomjs = parent.document.attributes['phantomjs']
          @phantomjs = ::Asciidoctor::Diagram.which('phantomjs') unless @phantomjs && File.executable?(@phantomjs)
          raise "Could not find the Phantom.js 'phantomjs' executable in PATH; add it to the PATH or specify its location using the 'phantomjs' document attribute" unless @phantomjs
        end

        args = [@phantomjs, HTML2SVG_PATH, "#{source_basename}.html"]
puts "d3js_to_svg args=#{args}"
        content = IO.popen(args, "r+") do |io|
          io.close_write
          io.read
        end

        doc = Nokogiri::XML(io.read)
        doc.encoding = 'UTF-8'
        root = doc.root()
        root.add_namespace(nil, 'http://www.w3.org/2000/svg')
        root.add_namespace('xlink', 'http://www.w3.org/1999/xlink')
        doc.to_xml
      end

      def self.included(mod)
        mod.register_format(:png, :image) do |c, p|
puts "png included c=#{c}, p=#{p}"
          d3js_to_png p, c
        end
        mod.register_format(:svg, :image) do |c, p|
puts "svg included c=#{c}, p=#{p}"
          d3js_to_svg p, c
        end
      end

      class Source < API::BasicSource
        attr_accessor :file_basename

        def initialize(file_basename)
          @file_basename = file_basename
        end

        def image_name
          file_basename
        end

        def code
          file_basename
        end

        def should_process?(image_file, image_metadata)
          #cacoo_metadata['updated'] < Time.rfc2822(image_metadata['updated'])
          true
        end

        def create_image_metadata
          { 'updated' => cacoo_metadata['updated'] }
        end

        def cacoo_metadata
          { udpated: Time.now }
        end
      end
    end

    class D3jsBlockProcessor < API::DiagramBlockProcessor
      include D3js

      def create_source(parent, reader, attributes)
puts "D3jsBlockProcessor#create_source reader.read.strip=#{reader.read.strip}, attributes=#{attributes}"
        D3js::Source.new(reader.read.strip)
      end
    end

    class D3jsBlockMacroProcessor < API::DiagramBlockMacroProcessor
      include D3js

      def create_source(parent, target, attributes)
puts "D3jsBlockMacroProcessor#create_source target=#{target}, attributes=#{attributes}"
        D3js::Source.new(target.strip)
      end
    end
  end
end
