require 'CSV'
require 'sqlite3'

# Inputs
db_name = './db/database.db'
filename = "./data/gpl_groups.csv"
table_name = "gpl_groups"

# Prepare DB & CSV
db = SQLite3::Database.open(db_name)
raw_csv_data = CSV.read(filename)

# Calculate number of rows
row_count = raw_csv_data.length - 1
current_row = 0
start_time = Time.now

puts "Inserting rows..."
(raw_csv_data[1..]).each do |row|
  # Calculate progress bar
  perc_complete = (current_row.to_f / row_count.to_f * 100).round(1)
  bar = "=" * (perc_complete.round()/5)
  space = " " * (20 - bar.length)

  # Calculate remaining time
  if current_row > 100
    elapsed_time = Time.now - start_time
    time_per_iteration = elapsed_time / current_row
    estimated_total_time = time_per_iteration * row_count
    estimated_time_left = estimated_total_time - elapsed_time # in seconds

    remaining_time_fmt = estimated_time_left.round.to_s + "s" + (" " * 10)
    if estimated_time_left > 60 && estimated_time_left < 3600
      # Show minutes and seconds
      minutes_left = (estimated_time_left / 60).floor
      seconds_left = (estimated_time_left % 60).floor
      remaining_time_fmt = "#{minutes_left}m #{seconds_left}s" + (" " * 10)
    elsif estimated_time_left > 3600
      hours_left = (estimated_time_left / 3600).floor
      minutes_left = ((estimated_time_left % 3600) / 60).floor
      remaining_time_fmt = "#{hours_left}h #{minutes_left}m" + (" " * 10)
    end
  else
    remaining_time_fmt = "Calculating..."
  end

  current_row += 1
  print "\r[#{bar}#{space}] #{perc_complete}% (#{current_row}/#{row_count}) | Time remaining: #{remaining_time_fmt}"
  db.execute("INSERT INTO #{table_name} VALUES (#{row.map { |col| col.nil? ? "NULL" : "'#{col}'" }.join(', ')})")
end

puts "\nDone!"