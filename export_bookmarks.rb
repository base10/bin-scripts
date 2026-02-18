#!/usr/bin/env ruby
# frozen_string_literal: true

require "debug"
require "pathname"
require "plist"
require "uri"
require "json"

BASE_PATH = Pathname.new(
  "/Users/nathan/SynologyDrive/Documents/walls.corpus/2025-11-safari-recovery/"
)

BOOKMARKS_PATH  = File.expand_path(BASE_PATH + "Bookmarks.xml")
OUTPUT_FILE     = File.expand_path(BASE_PATH + "prior_bookmarks.md")

unless File.exist?(BOOKMARKS_PATH)
  abort "#{BOOKMARKS_PATH} not found"
end

file_handle = File.open(BOOKMARKS_PATH)
                  .read
                  .force_encoding("utf-8")

bookmarks   = Plist.parse_xml(file_handle)

def find_reading_list_folder(bookmarks)
  (bookmarks['Children'] || []).each do |folder|
    return folder if folder['Title'] == 'com.apple.ReadingList'
  end
  nil
end

reading_list = find_reading_list_folder(bookmarks)

unless reading_list
  abort "❌ Could not locate the Reading List folder in Bookmarks.xml"
end

# -------------------------------------------------------------------
# Step 2 – Gather items ----------------------------------------------
items = []

(reading_list['Children'] || []).each do |entry|
  title       = entry['URIDictionary']['title']
  site_name   = entry['ReadingListNonSync']['siteName'] # TODO: Parse the URL domain
  preview     = entry['ReadingList']['PreviewText']
  url         = entry['URLString']
  added_at    = entry['ReadingList']['DateAdded'] || Time.now
  fmt_added_at = added_at.io8601

  items << {
    title: title,
    site_name: site_name,
    preview: preview,
    url: url,
    added: fmt_added_at
  }
end

if items.empty?
  abort "ℹ️  No items found in the Reading List."
end


# -------------------------------------------------------------------
# Step 3 – Build Markdown ---------------------------------------------

markdown = []
markdown << +"# Safari Reading List\n\n"
markdown << "*Generated on #{Time.now.utc.iso8601}*\n\n"

items.each_with_index do |item, idx|
  entry = <<EOL
## #{idx + 1}. #{item[:title]}

Added: #{item[:added_at]}
Site: #{item[:site_name]}
URL: [#{item[:url]}](#{item[:url]})

#{item[:preview]}

EOL

  markdown << entry
end

# -------------------------------------------------------------------
# Step 4 – Write to file ---------------------------------------------
File.write(OUTPUT_FILE, markdown.join)
puts "✅ Markdown written to #{OUTPUT_FILE}"
