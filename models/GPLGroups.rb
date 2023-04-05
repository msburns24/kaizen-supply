<<<<<<< HEAD
require_relative "../utils/msb_daru"
require_relative "FiscalDates"

class GPLGroups < Daru::DataFrame

  def self.join_with(df)
    filename = "data/gpl_groups.csv"
    gpl_groups = Daru::DataFrame.from_csv_with_types(filename)
    df = df.join(gpl_groups, on: ["material_number"], how: :left)
    df["gpl_group"] = df["gpl_group"].map { |gpl| gpl.nil? ? "All Others" : gpl }
    return df
  end
=======
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
>>>>>>> 700c2466cc18a58253728d317424c1afe1c8bff9
end