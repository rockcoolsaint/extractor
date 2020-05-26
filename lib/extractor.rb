require 'erb'
require 'nokogiri'
require "opengraph_parser"
require 'open-uri'
require 'workers'

class Extractor
  def call(env)
    @meta_list = extract

    request = Rack::Request.new(env)
    Rack::Response.new(render("output.html.erb")).finish
  end

  def extract
    doc = Nokogiri::HTML(open("./lib/cats.html"))
    anchor_tags = doc.xpath("//th[@scope='row']/a[@title!='Wila Krungthep (page does not exist)']")

    hrefs = []
    anchor_tags.each do |tag|
      hrefs << tag[:href]
    end

    # Initialize a worker pool.
    pool = Workers::Pool.new(
      :size => 100,
      :on_exception => proc { |e|
      puts "A worker encountered an exception: #{e.class}: #{e.message}"
    })

    meta_list = []
    hrefs.each do |href|
      pool.perform do
        meta_list << {
          title: Nokogiri::HTML.parse(open(href)).title,
          image: OpenGraph.new(href).images[0]
        }
      end
    end

    # Wait up to 30 seconds for the workers to cleanly shutdown (or forcefully kill them).
    pool.dispose(30) do
      puts "Worker thread #{Thread.current.object_id} is shutting down."
    end

    return meta_list
  end

  def render(template)
    path = File.open("#{__dir__}/#{template}")
    ERB.new(File.read(path)).result(binding)
  end
end