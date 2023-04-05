require 'CSV'
require 'sqlite3'
require_relative "utils/utils"
require 'terminal-table'

db_filename = "./ICTCR.db"
db = SQLite3::Database.new(db_filename)

tables = table_names(db)

table_info = {}
tables.each do |table|
  table_info[table] = {
    columns: [],
    rows: format_commas(row_count(db, table.to_s))
  }
  column_types(db, table).each do |column|
    table_info[table][:columns] << [column[0], column[1]]
  end
end

table_info.each do |table, info|
  puts "Table:    #{table}"
  puts "Entries:  #{info[:rows]}"
  puts Terminal::Table.new(rows: info[:columns])
  puts ""
end