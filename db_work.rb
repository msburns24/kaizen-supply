require 'CSV'
require 'sqlite3'

def format_headers(header_array)
  return header_array.map { |col_name| col_name.gsub(" ", "_").gsub(".", "") }
end

data = CSV.read('./output-data.csv')

db = SQLite3::Database.open 'test.db'

# CREATE TABLE MyTable(
#   id int,
#   name varchar(10),
#   ...
# )