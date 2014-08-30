# Asciidoctor::Diagram::D3js

An extension to [asciidoctor-diagram](https://github.com/asciidoctor/asciidoctor-diagram) for including diagrams created with [D3.js]( http://d3js.org/ ).
This extension open html files using D3.js with Phantom.js, convert them to png or svg files, and include them in asciidoc documents.

## Installation

### Install this extension

Add this line to your application's Gemfile:

```ruby
gem 'asciidoctor-diagram-d3js'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install asciidoctor-diagram-d3js

### Install PhantomJS

Please read [PhantomJS Documentation]( http://phantomjs.org/documentation/ ) and install PhantomJS.

## Usage

sample.adoc

```
.example class diagram
d3js::class-diagram[format="svg"]
```

You must specify the basename of the html file (like 'class-diagram' in the above example)
and you must have the html file with '.html' extension ('class-diagram.html' in this example).

You can use "png" or "svg" for format.

If format is "png", we use phantomjs to open the html file and take a screenshot of the page.
If format is "svg", we use phantomjs to open the html file and get the innerHTML of the first 'div' element as the svg content.

## Example

You can see a full example at https://github.com/hnakamur/asciidoctor-diagram-d3js-example

## Contributing

1. Fork it ( https://github.com/hnakamur/asciidoctor-diagram-d3js/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
