require "sqlite3"
require 'terminal-table'
require_relative "utils/utils"

db = SQLite3::Database.open "./ICTCR.db"

statement = <<-SQL
  select region as Region, sum(PCF_amt) as 'Total PCF'
  from PCF
  inner join (
    select distinct fiscal_month_id, fiscal_quarter_label
    from dates
  )
  on fiscal_month = fiscal_month_id
  where fiscal_quarter_label = 'FY23-Q3'
  group by region
SQL

raw_data = db.execute2 statement

total = 0
raw_data[1..].each do |row|
  total += row[1].to_i
end

table = Terminal::Table.new do |t|
  t.headings = raw_data[0]
  t.rows = raw_data[1..].map {|m, val| [m, format_commas(val.to_i / 1000000)]}
  t.align_column(2, :right)
  t.add_separator
  t.add_row ["Total", format_commas(total/1000000)]
  t.align_column(2, :right)
end

puts table