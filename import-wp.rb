require 'rexml/document'
require 'date'
require 'fileutils'

include REXML # so that we don't have to prefix everything with REXML::...

file = File.new( "wordpress.2009-02-11.xml" )
doc = REXML::Document.new file

entries = []

doc.elements.each("//item") do |element| 
  title = element.get_text("title")
  post_name = element.get_text("wp:post_name")
  datestr = "#{element.get_text("pubDate")}"
  d = DateTime.parse(datestr).strftime("%Y-%m-%d")
  desc = element.get_text("content:encoded")
  category = element.get_text("category")
  category = "Blogging" if category == "" or category.nil?
  puts category 
  puts d
  puts title
  puts post_name
  dir = "_posts/#{category}/"
  FileUtils.mkdir(dir) if !File.exists?(dir)
  filename = dir + "#{d}-#{post_name}.html"
  post = "---\n"
  post += "layout: post\n"
  post += "title: #{title}\n"
  post += "---\n"
  post += desc.to_s.gsub("â€™", "'").gsub("\n\n", "<br/>\n")
  File.open(filename, 'w') { |f| f.write(post) }
end



