require "sqlite3"
require 'terminal-table'
require_relative "./utils/utils.rb"

db = SQLite3::Database.open "./db/database.db"
table_name = "pcf_by_part"

# Select the first 10 rows from the pcf_by_part table
# join with the gpl_groups on the material_number
statement = <<-SQL
  SELECT DISTINCT material_number
  FROM #{table_name}
  WHERE material_number not in (
    SELECT material_number
    FROM gpl_groups
  )
  ORDER BY material_number
SQL

rows = (db.execute statement).map { |row| row << "All Other" }

p rows