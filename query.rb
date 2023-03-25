require "sqlite3"
require 'terminal-table'
require_relative "./utils/utils.rb"
require_relative "./models/GPLGroups.rb"

db = SQLite3::Database.open "./db/database.db"
# table_name = "pcf_by_part"
# col_names = column_names(db, table_name)

statement = <<-SQL
  SELECT COUNT(*)
  FROM gpl_groups
  WHERE gpl_group IS NULL OR gpl_group = ""
SQL

rows = db.execute statement

# table = Terminal::Table.new :headings => col_names, :rows => rows

table = Terminal::Table.new :rows => rows
puts table

puts GPLGroup.count