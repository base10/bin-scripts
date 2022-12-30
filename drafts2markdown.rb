#!/usr/bin/env ruby

require "date"
require "debug"
require "json"
require "pathname"

class DraftsMarkdownConverter
  DATE_FORMAT = "%Y-%m-%d".freeze

  attr_accessor(
    :errors,
    :file_prefix,
    :input_file,
    :input,
    :input_pathname,
    :output_dir,
    :output_pathname
  )

  def initialize(file_prefix:, input_file:, output_dir:)
    @errors = []
    @file_prefix = file_prefix
    @input_file = input_file
    @output_dir = output_dir
  end

  def run
    confirm_io
    read_input

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

    # TODO: Confirm the things exist or raise errors
    puts output_pathname.directory?
  end

  def convert_drafts_json
    # iterate over the JSON and process each entry
    # Use the metadata to create a URL safe file name leading with YYYY-MM-DD
    # based on the creation date
      # Disambiguate files as needed

    # TODO: pull the reporting count from input size

    #input.each_with_index { |item, index| write_item(index: index, item: item) }
    write_item(index: 0, item: input.first)
  end

  def report_errors
  end

  def report_status
  end

  def file_pathname(index:, item:)
    draft_creation_date = draft_creation_date(item: item)
    file_name = "#{draft_creation_date}-#{file_prefix}-#{index}.md"

    output_pathname.join(file_name)
  end

  def write_item(index:, item:)
    # Use #file_name
      # create the file with file metadata based on what was put into Drafts and
      # exists in the Drafts entry metadata

    # Second or subsequent iteration, use an in-line ERb template
    File.write(
      file_pathname(index: index, item: item),
      item["content"]
    )
  end

  def draft_creation_date(item:)
    Date.strptime(item.fetch("created_at"), DATE_FORMAT)
   end

  # Possibly have a new class for entries themselves?
    # Leave that for later extraction
end

# TODO: Find examples of using opts parser vs. positional args

input_file = ARGV.shift
output_dir = ARGV.shift

converter = DraftsMarkdownConverter.new(
  file_prefix: "dayplan".freeze,
  input_file: input_file,
  output_dir: output_dir
)

converter.run
