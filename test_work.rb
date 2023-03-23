require 'CSV'
require 'sqlite3'
require_relative './utils/utils'
require_relative './models/TestTable'

# db_name = 'test.db'
# db = SQLite3::Database.open db_name

# csv_filename = './test_data.csv'
# CSV.foreach(csv_filename, headers:true, col_sep: ",") do |row|
#   row_arr = row.to_a.map { |colname, val| (is_integer?(val) ? val.split(',').join.to_i : val) }
#   db.execute "insert into test_table values (?, ?, ?)", row_arr
# end

# p db.execute "select * from test_table"
# puts db.execute "select sum(qty) from test_table"

p TestTable.column_types