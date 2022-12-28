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
  end

  def convert_drafts_json
  end
end

# TODO: Find examples of using opts parser
