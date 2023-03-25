require "sqlite3"
require 'terminal-table'
require_relative "./utils/utils.rb"

db = SQLite3::Database.open "./db/database.db"
table_name = "pcf_by_part"

# Select the first 10 rows from the pcf_by_part table
# join with the gpl_groups on the material_number
statement = <<-SQL
  SELECT gpl_group, sum(pcf_amt) AS total_pcf_amt
  FROM #{table_name}
  INNER JOIN gpl_groups
  ON #{table_name}.material_number = gpl_groups.material_number
  GROUP BY gpl_group
SQL

rows = db.execute statement
col_names = column_names(db, table_name)

# table = Terminal::Table.new :headings => col_names, :rows => rows

table = Terminal::Table.new :rows => rows

puts table