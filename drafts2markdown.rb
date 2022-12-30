#!/usr/bin/env ruby

# TODO: Find examples of using opts parser vs. positional args
require "debug"
require_relative "./lib/drafts_markdown_converter"

input_file = ARGV.shift
output_dir = ARGV.shift

converter = DraftsMarkdownConverter.new(
  file_prefix: "dayplan".freeze,
  input_file: input_file,
  output_dir: output_dir
)

converter.run
