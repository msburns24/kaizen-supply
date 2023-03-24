require 'sqlite3'

class KaizenDataMigration
  @@db = SQLite3::Database.open "./db/database.db"

  private
    def self.create_table(table_name, columns_hash)
      statement = "CREATE TABLE IF NOT EXISTS #{table_name}"
      statement += "(#{sql_columns(columns_hash)})"
      @@db.execute statement
    end

    def self.sql_columns(columns_hash)
      columns_array = []
      columns_hash.each do |name, type|
        columns_array << "#{name.to_s} #{type.to_s.upcase}"
      end
      return columns_array.join(", ")
    end
end


class CreatePCFByPartTable < KaizenDataMigration
  def self.migrate
    create_table "pcf_by_part", {
      material_number: :string,
      fiscal_month: :string,
      pcf_amt: :integer,
      pcf_units: :integer
    }
  end
end


CreatePCFByPartTable.migrate()