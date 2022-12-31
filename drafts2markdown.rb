#!/usr/bin/env ruby

require "debug"
require "optparse"

require_relative "./lib/drafts_markdown_converter"

options = {}
opt_parser = OptionParser.new do |parser|
  parser.banner = "Usage: drafts2markdown.rb [options]"

  parser.on("-h", "--help", "Prints this help message") do
    puts "Here's a help message!"

    exit
  end
end

# I'm not clear on when I need to call parse vs. parse!
options = opt_parser.parse!

p options

input_file = ARGV.shift
output_dir = ARGV.shift

# converter = DraftsMarkdownConverter.new(
#   file_prefix: "dayplan".freeze,
#   input_file: input_file,
#   output_dir: output_dir
# )
#
# converter.run
