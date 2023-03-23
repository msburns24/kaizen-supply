class TestTable
  @@db_name = 'test.db'
  @@db = SQLite3::Database.open @@db_name
  @@table_name = "test_table"

  def self.all
    @@db.execute <<-SQL
      SELECT * from #{@@table_name};
    SQL
  end

  def self.column_names
    # Outputs an array, each item in the form:
    # [column_name, datatype, notnull, default_val, primary_key?]
    raw_schema = @@db.execute <<-SQL
      PRAGMA table_info(#{@@table_name});
    SQL
    
    # Convert to array
    raw_schema.map { |col_arr| col_arr[1] }
  end

  def self.column_types
    raw_schema = @@db.execute <<-SQL
      PRAGMA table_info(#{@@table_name});
    SQL
    raw_schema.map { |col_arr| col_arr[1..2] }
  end
end