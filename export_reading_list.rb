#!/usr/bin/env ruby
# frozen_string_literal: true

require 'plist'
require 'time'
require 'tempfile'

BOOKMARKS_PATH = File.expand_path('~/Library/Safari/Bookmarks.plist')
OUTPUT_FILE   = File.expand_path('~/Desktop/SafariReadingList.md')

unless File.exist?(BOOKMARKS_PATH)
  abort "❌ Bookmarks.plist not found at #{BOOKMARKS_PATH}"
end

xml_plist = Tempfile.new(['bookmarks', '.xml'])
xml_plist.close
system('plutil', '-convert', 'xml1', '-o', xml_plist.path, BOOKMARKS_PATH)

bookmarks = Plist.parse_xml(xml_plist.path)
xml_plist.unlink

def find_reading_list_folder(bookmarks)
  (bookmarks['Children'] || []).each do |folder|
    title = folder['Title']
    return folder if title == 'Reading List' || title == 'com.apple.ReadingList'
  end
  nil
end

reading_list = find_reading_list_folder(bookmarks)

unless reading_list
  abort "❌ Could not locate the Reading List folder in Bookmarks.plist"
end

puts "Reading List Children count: #{reading_list['Children']&.length || 0}"

items = []
skipped = 0

(reading_list['Children'] || []).each do |entry|
  url = entry['URIString'] || entry['URLString']
  unless url
    skipped += 1
    next
  end

  title       = entry['URIDictionary']&.[]('title') || entry['Title']
  title       = url if title.nil? || title.empty?
  added_at    = begin
    entry['dateAdded'] ? Time.at(entry['dateAdded'].to_i / 1_000_000).utc.iso8601 : nil
  rescue
    nil
  end
  description = entry['previewText'] || ''

  items << { title:, url:, added: added_at, description: }
end

puts "Items found: #{items.length}, Skipped (no URL): #{skipped}"

if items.empty?
  abort "ℹ️  No items found in the Reading List."
end

markdown = +"# Safari Reading List\n\n"
markdown << "*Generated on #{Time.now.utc.iso8601}*\n\n"

items.each_with_index do |item, idx|
  markdown << "## #{idx + 1}. [#{item[:title]}](#{item[:url]})\n\n"

  if item[:added]
    markdown << "_Added:_ #{item[:added]}\n\n"
  end

  if item[:description] && !item[:description].empty?
    markdown << "#{item[:description]}\n\n"
  end

  markdown << "---\n\n"
end

File.write(OUTPUT_FILE, markdown)
puts "✅ Markdown written to #{OUTPUT_FILE}"
