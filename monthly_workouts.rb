#!/usr/bin/env ruby

# Take a month and year as input
# Convert to a date object
# Find every Sunday, Tuesday, Thursday and return an array
# Print the array as `- YYYY-MM-DD` format

require "date"

DEFAULT_DATE = 1

# Second iteration: Move these to OptionParser options.
year  = ARGV.shift
month = ARGV.shift
day   = DEFAULT_DATE

date = Date.new(year.to_i, month.to_i, day.to_i)


# Calculate the last day of the current month.
  # Find out if there's any logic about months in terms of number of days
def limit_date(date)
  next_month = date.next_month
  end_of_month = next_month - 1
end

def matched_day?(date)
  date.sunday? || date.tuesday? || date.thursday?
end

limit = limit_date(date)
candidate_dates = date.step(limit)

candidate_dates.each do |candidate|
  next unless matched_day?(candidate)

  puts "- #{candidate.iso8601}"
end
