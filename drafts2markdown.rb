#!/usr/bin/env ruby

require "debug"
require "json"
require "pathname"

class DraftsMarkdownConverter
  attr_accessor(
    :errors, :input_file, :input, :input_pathname, :output_dir, :output_pathname
  )

  def initialize(input_file:, output_dir:)
    @errors = []
    @input_file = input_file
    @output_dir = output_dir
  end

  def run
    confirm_io
    read_input

binding.break

    convert_drafts_json

    report_errors
    report_status
  end

  private

  def read_input
    @input = JSON.parse(input_pathname.read)
  end

  # Directory should exist and be writable
  # Future iterations might consider creating a missing directory structure
  def confirm_io
    errors = []

    # TODO: Look at the path parts and if the first element is `~`, swap it out
    # for the HOME env var.

    @input_pathname = Pathname.new(input_file)
    @output_pathname = Pathname.new(output_dir)

    puts output_pathname.directory?
  end

  def convert_drafts_json
    # iterate over the JSON and process each entry
    # Use the metadata to create a URL safe file name leading with YYYY-MM-DD
    # based on the creation date
      # Disambiguate files as needed

    # TODO: pull the reporting count from input size

binding.break

    input.each do |item|
    end
  end

  def report_errors
  end

  def report_status
  end

  def item_title(item)
  end

  def write_item(item)
    # Use #item_title
      # create the file with file metadata based on what was put into Drafts and
      # exists in the Drafts entry metadata

  end

  # Possibly have a new class for entries themselves?
    # Leave that for later extraction
end

# TODO: Find examples of using opts parser vs. positional args
input_file_name = ARGV.shift
output_dir = ARGV.shift

converter = DraftsMarkdownConverter.new(
  input_file: input_file_name,
  output_dir: output_dir
)

converter.run
