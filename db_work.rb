require 'CSV'
require 'sqlite3'
require_relative "utils/utils"

filename = "test.db"
db = SQLite3::Database.new(filename)