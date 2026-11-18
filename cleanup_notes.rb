#!/usr/bin/env ruby

require "optparse"
require "fileutils"
require "date"

def cleanup_notes(base_path)
  unless Dir.exist?(base_path)
    puts "Error: Path does not exist: #{base_path}"
    exit(1)
  end

  # Iterate through each subdirectory in the base path (e.g., "well-ronfim")
  Dir.foreach(base_path) do |entry|
    next if entry == "." || entry == ".."
    
    subdir_path = File.join(base_path, entry)
    next unless File.directory?(subdir_path)

    # Find files starting with YYYY-MM-DD and ending in .md
    Dir.foreach(subdir_path) do |file|
      next if file == "." || file == ".."
      file_path = File.join(subdir_path, file)
      next unless File.file?(file_path) && file.match?(/^\d{4}-\d{2}-\d{2}-.*\.md$/)

      begin
        # Extract the date portion (YYYY-MM-DD)
        date_str = file.split("-").first(3).join("-")
        date_obj = Date.parse(date_str)
        
        year = date_obj.year.to_s
        month = date_obj.month.to_s.rjust(2, '0')
        
        # Target path: subdir/year/month/filename
        target_dir = File.join(subdir_path, year, month)
        FileUtils.mkdir_p(target_dir)
        
        FileUtils.move(file_path, File.join(target_dir, file))
        puts "Moved: #{file} -> #{year}/#{month}/"
      rescue => e
        warn "Failed to move #{file}: #{e.message}"
      end
    end
  end
end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: cleanup_notes.rb [options]"

  opts.on("-p", "--path PATH", String, "Base path to clean up") do |v|
    options[:path] = v
  end
end

parser.parse!

# Determine path from options or first argument
path = options[:path] || ARGV[0]

if path.nil?
  puts "Error: No path provided."
  puts parser
  exit(1)
end

cleanup_notes(File.expand_path(path))
