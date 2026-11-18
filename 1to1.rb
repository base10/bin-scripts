#!/usr/bin/env ruby

require "optparse"
require "erb"
require "debug"
require "fileutils"

class OneToOneMeeting
  BASE_DIR = File.expand_path("~/Documents/vitalsource/one-on-one-notes")
  TEMPLATE_RELATIVE_PATH = "/tmpl/one-to-one.md.erb"

  attr_accessor :meeting_notes_markdown
  attr_reader :date, :name, :output_dir

  def initialize(date:, name:, output_dir: nil)
    @date = date
    @name = name
    @output_dir = output_dir
  end

  def run
    generate_meeting_notes
    save_to_file
  end

  def name_for_file
    name.downcase.gsub(" ", "-")
  end

  def file_name
    "#{date}-#{name_for_file}.md".freeze
  end

  def output_path
    if @output_dir
      # If output_dir is provided, use it.
      # If it doesn't end in a slash, ensure one is added before the filename.
      base = @output_dir
      base = File.join(base, "") unless base.end_with?("/")
      base + "/" + file_name
    else
      sub_dir = name_for_file
      # Parse the date provided by the user to get year and month
      # Expected format: YYYY-MM-DD
      parts = date.split("-")
      year = parts[0] || "0000"
      month = parts[1] || "00"

      # Construct path: BASE_DIR/name_for_file/YYYY/MM/YYYY-MM-DD-name_for_file.md
      specific_file_name = "#{date}-#{sub_dir}.md"
      File.join(BASE_DIR, sub_dir, year, month, specific_file_name)
    end
  end

  def generate_meeting_notes
    template = File.read(template_path)
    markdown = ERB.new(template, trim_mode:  "%-")

    @meeting_notes_markdown = markdown.result(get_binding)
  end

  def get_binding
    binding
  end

  def template_path
    File.expand_path(File.dirname(__FILE__)) + TEMPLATE_RELATIVE_PATH
  end

  def save_to_file
    # Ensure the directory exists before writing
    FileUtils.mkdir_p(File.dirname(output_path))
    File.open(output_path, 'w') do |file|
      file.write meeting_notes_markdown
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: meeting_notes.rb [options]"

  opts.on("-d DATE", "--date=DATE", String) { |v| options[:date] = v }
  opts.on("-n NAME", "--name=NAME", String) { |v| options[:name] = v }
  opts.on(
    "-o DIRECTORY", "--output-directory=DIRECTORY", String
  ) { |v| options[:dir] = v }
end.parse!

if !options[:date] || !options[:name]
  puts "Error: Date and Name are required arguments"
  exit(1)
end

meeting = OneToOneMeeting.new(
  date: options[:date],
  name: options[:name],
  output_dir: options[:dir]
)

meeting.run

puts "Saved #{meeting.file_name}"
