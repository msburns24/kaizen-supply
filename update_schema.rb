require 'CSV'
require 'sqlite3'
require_relative "utils/utils"

filename = "test.db"
db = SQLite3::Database.new(filename)

tables = table_names(db)

table_info = {}
tables.each do |table|
  table_info[table] = []
  column_types(db, table).each do |column|
    table_info[table] << column
  end
end

File.open("schema.txt", "w") do |f|
  table_info.each do |table, columns|
    f.puts "#{table}:"
    columns.each do |column|
      f.puts "\t#{column.join(":")}"
    end

    f.puts ""
  end
end