require 'CSV'
require 'sqlite3'
require_relative "utils/utils"

db_filename = ARGV[0]
db = SQLite3::Database.new(db_filename)

tables = table_names(db)

table_info = {}
tables.each do |table|
  table_info[table] = {
    column_names: [],
    column_types: [],
    rows: row_count(db, table)
  }
  column_types(db, table).each do |column|
    table_info[table][:column_names] << column[0]
    table_info[table][:column_types] << column[1]
  end
end

table_info.each do |table, info|
  puts "#{table} (#{info[:rows]} rows)"
  puts "  #{info[:column_names].join(', ')}"
  puts ""
end