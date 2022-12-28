#!/usr/bin/env ruby

require "debug"
require "fileutils"
require "json"

class DraftsMarkdownConverter
  attr_accessor :input_file, :input, :output_dir

  def initialize(input_file:, output_dir:)
    @input_file = input_file
    @output_dir = output_dir
  end

  def run
    read_input
    confirm_output_dir
    convert_drafts_json
  end

  private

  def read_input
  end

  def confirm_output_dir
    # Directory should exist and be writable
    # Future iterations might consider creating a missing directory structure
  end

  def convert_drafts_json
    # iterate over the JSON and process each entry
    # Use the metadata to create a URL safe file name leading with YYYY-MM-DD
    # based on the creation date
      # Disambiguate files as needed
  end
end

# TODO: Find examples of using opts parser vs. positional args
input_file_name = ARGV.shift
output_dir = ARGV.shift

# TODO: Check if I need Pathname
input_file = File.path(Pathname.new(input_file_name))

converter = DraftsMarkdownConverter.new(
  input_file: input_file,
  output_dir: output_dir
)

converter.run
