#!/usr/bin/env ruby

require "optparse"

class ResponsiveImage
end

class ResponsiveImageSet
end

class ResponsiveImageBuilder
  attr_accessor :input_dir, :input_files, :output_dir

  def initialize(input_dir:, input_files:, output_dir:)
    @input_dir = input_dir
    @input_files = input_files
    @output_dir = output_dir
  end

  def call
  end
end

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: responsives.rb [options]"

  parser.on(
    "-iINPUT",
    "--input_dir=INPUT",
    String,
    "Directory the source images are from"
  ) do |input_dir|
    options[:input_dir] = input_dir
  end

  parser.on(
    "-fFILES",
    "--input_files=FILES",
    Array,
    "File(s) to act on for input"
  ) do |input_files|
    options[:input_files] = Array(input_files)
  end

  parser.on(
    "-oOUTPUT",
    "--output_dir=OUTPUT",
    String,
    "Directory to output processed responsive images to"
  ) do |output_dir|
    options[:output_dir] = output_dir
  end

  parser.on("-h", "--help", "Prints this help") do
    puts parser
    exit
  end
end.parse!

builder = ResponsiveImageBuilder.new(
  input_dir: options[:input_dir],
  input_files: options[:input_files],
  output_dir: options[:output_dir]
)

builder.call
