require 'active_support/core_ext/string'
require 'sqlite3'

class Model
  @@db = SQLite3::Database.open './db/database.db'

  def self.table_name
    # Converts CamelCase to snake_case
    table_name_array = self.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/([A-Z])([A-Z])([a-z])/, '\1_\2\3').downcase.split("_")
    if table_name_array.length == 1
      return table_name_array[0].pluralize
    else
      return (table_name_array[0..-2] << table_name_array[-1].pluralize).join('_')
    end
  end

  def self.count
    @@db.execute("SELECT COUNT(*) FROM #{table_name}")[0][0]
  end
  
  def self.column_names
    @@db.execute("PRAGMA table_info(#{table_name})").map { |row| row[1] }
  end
end