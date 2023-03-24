require 'CSV'
require 'sqlite3'

db_name = './db/database.db'
db = SQLite3::Database.open(db_name)
table_name = "pcf_by_part"

filename = "./data/pcf_by_pn.csv"
raw_csv_data = CSV.read(filename)

(raw_csv_data[1..]).each do |row|
  db.execute("INSERT INTO #{table_name} VALUES (#{row.map { |col| col.nil? ? "NULL" : "'#{col}'" }.join(', ')})")
end