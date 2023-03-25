require 'sqlite3'
require_relative "./Model.rb"

# class GPLGroup
#   @@db = SQLite3::Database.open './db/database.db'
#   @@table_name = "gpl_groups"

#   def self.count
#     @@db.execute("SELECT COUNT(*) FROM #{@@table_name}")[0][0]
#   end
  
#   def self.column_names
#     @@db.execute("PRAGMA table_info(#{@@table_name})").map { |row| row[1] }
#   end
# end

class GPLGroup < Model
end