#!/usr/bin/env ruby
# frozen_string_literal: true

require 'plist'          # gem install plist  (only dependency)
require 'net/http'
require 'uri'
require 'time'

# -------------------------------------------------------------------
# Configuration ------------------------------------------------------
BOOKMARKS_PATH = File.expand_path('~/Library/Safari/Bookmarks.plist')
OUTPUT_FILE   = File.expand_path('~/Desktop/SafariReadingList.md')
TIMEOUT       = 10          # seconds for HTTP requests

# -------------------------------------------------------------------
# Helpers ------------------------------------------------------------
def safe_fetch(url)
  uri = URI.parse(url)

  # Respect https:// and http://
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')
  http.open_timeout = TIMEOUT
  http.read_timeout = TIMEOUT

  request = Net::HTTP::Get.new(uri.request_uri)
  request['User-Agent'] = 'Mozilla/5.0 (Ruby)'

  begin
    response = http.request(request)
    return response.body if response.is_a?(Net::HTTPSuccess)
  rescue StandardError => e
    warn "⚠️  Could not fetch #{url}: #{e.message}"
  end

  ''
end

def extract_snippet(html)
  # Prefer <meta name="description">, otherwise the <title> tag.
  if html =~ /<meta\s+name=["']description["']\s+content=["']([^"']+)["']/i
    $1.strip
  elsif html =~ /<title>([^<]+)<\/title>/i
    $1.strip
  else
    ''
  end
end

# -------------------------------------------------------------------
# Step 1 – Load Safari bookmarks -------------------------------------
unless File.exist?(BOOKMARKS_PATH)
  abort "❌ Bookmarks.plist not found at #{BOOKMARKS_PATH}"
end

bookmarks = Plist.parse_xml(BOOKMARKS_PATH)

def find_reading_list_folder(bookmarks)
  (bookmarks['Children'] || []).each do |folder|
    return folder if folder['Title'] == 'Reading List' && folder['Type'] == 0
  end
  nil
end

reading_list = find_reading_list_folder(bookmarks)

unless reading_list
  abort "❌ Could not locate the Reading List folder in Bookmarks.plist"
end

# -------------------------------------------------------------------
# Step 2 – Gather items ----------------------------------------------
items = []

(reading_list['Children'] || []).each do |entry|
  next unless entry['Type'] == 1 # Bookmark item

  title   = entry['Title']
  url     = entry['URLString']
  added_at = Time.at(entry['DateAdded'].to_i).utc.iso8601 rescue nil

  items << { title:, url:, added: added_at }
end

if items.empty?
  abort "ℹ️  No items found in the Reading List."
end

# -------------------------------------------------------------------
# Step 3 – Build Markdown ---------------------------------------------
markdown = +"# Safari Reading List\n\n"
markdown << "*Generated on #{Time.now.utc.iso8601}*\n\n"

items.each_with_index do |item, idx|
  markdown << "## #{idx + 1}. [#{item[:title]}](#{item[:url]})\n\n"

  html = safe_fetch(item[:url])
  snippet = extract_snippet(html)

  if snippet && !snippet.empty?
    markdown << "_Snippet:_ #{snippet}\n\n"
  else
    markdown << "*No description available.*\n\n"
  end

  markdown << "---\n\n"
end

# -------------------------------------------------------------------
# Step 4 – Write to file ---------------------------------------------
File.write(OUTPUT_FILE, markdown)
puts "✅ Markdown written to #{OUTPUT_FILE}"
