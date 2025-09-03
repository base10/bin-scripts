#!/usr/bin/env ruby

require "optparse"
require "erb"
require "debug"

class OneToOneMeeting
  TEMPLATE_RELATIVE_PATH = "/tmpl/one-to-one.md.erb"

  attr_accessor :meeting_notes_markdown
  attr_reader :date, :name, :output_dir

  def initialize(date:, name:, output_dir:)
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
    @output_dir + "/" + file_name
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

if !options[:date] || !options[:name] || !options[:dir]
  puts "Error: All required arguments are necessary"

  exit(1)
end

meeting = OneToOneMeeting.new(
  date: options[:date],
  name: options[:name],
  output_dir: options[:dir]
)

meeting.run

puts "Saved #{meeting.file_name}"
