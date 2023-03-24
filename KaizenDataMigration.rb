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


class CreateProductTable < KaizenDataMigration
  def self.migrate
    create_table "products", {
      title: :string,
      posting_date: :date,
      qty: :integer      
    }
  end
end


# CreateProductTable.migrate()

p ARGV
puts "Class: #{ARGV.class}"