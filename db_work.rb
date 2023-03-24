require 'CSV'
require 'sqlite3'
require_relative "utils/utils"

filename = "test.db"
db = SQLite3::Database.new(filename)
table_name = "pcf_by_region"
csv_file = CSV.open("./sampledata/PCF_by_Region.csv")

# add_csv_to_db(db, table_name, csv_file)

output = db.execute <<-SQL
  SELECT region, sum(pcf_amt)
  from pcf_by_region
  where fiscal_quarter = 'FY23-Q3'
  group by region
SQL

output.each do |region, pcf_amt|
  pcf_amt = (pcf_amt/1000).to_s.reverse.scan(/\d{3}|.+/).join(",").reverse
  puts "#{region}: #{pcf_amt}"
end

# FY23-Q3