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

  def self.create(data_hash = {})
    input_cols = data_hash.keys.map { |col| col.to_s }
    missing = column_names - input_cols
    extra = input_cols - column_names

    if missing.any? || extra.any?
      puts "The following errors prevented save:"
      puts "Missing columns from input: #{missing.to_s}" if missing.any?
      puts "Input columns not in table: #{extra.to_s}" if extra.any?
      puts ""
      return
    end

    # Format values
    data_hash.each do |key, val|
      type = column_types.find { |col_arr| col_arr[0] == key.to_s }[1]
      if type == "INTEGER"
        data_hash[key] = val.to_s.split(",").join.to_i
      else
        data_hash[key] = val.to_s
      end
    end

    # Map values and insert into DB
    values = column_names.map { |col| data_hash[col.to_sym] }
    @@db.execute "
      insert into #{@@table_name} 
      (#{column_names.join(", ")}) 
      values (#{values.map { |val| "?" }.join(", ")});
    ", values
  end
end