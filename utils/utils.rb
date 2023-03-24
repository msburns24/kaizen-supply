def table_names(db)
  return db.execute(
    "select name from sqlite_schema where type='table' and name not like 'sqlite_%'"
  ).map { |table| table[0] }
end

def column_names(db, table_name)
  column_attr = db.execute("PRAGMA table_info(#{table_name})")
  column_attr.map { |col| col[1] }
end

def column_types(db, table_name)
  column_attr = db.execute("PRAGMA table_info(#{table_name})")
  column_attr.map { |col| col[1..2] }
end

def row_count(db, table_name)
  db.execute("SELECT COUNT(*) FROM #{table_name}")[0][0]
end

def is_integer?(num)
  num.delete(',').to_i.to_s == num
end

def get_input(prompt, valid_responses = [])
  input = ""
  until valid_responses.include?(input)
    system "cls"
    print("\r#{prompt}: ")
    input = gets.chomp.strip.upcase
  end
  input
end

def add_csv_to_db(db, table_name, csv_file)
  # get column names from csv
  column_names = csv_file.shift.map { |col| col.gsub(" ", "_").gsub(".", "").downcase }
  # insert rows
  csv_file.each do |row|
    db.execute("INSERT INTO #{table_name} VALUES (#{row.map { |col| col.nil? ? "NULL" : "'#{col}'" }.join(', ')})")
  end
end