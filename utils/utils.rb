def list_tables(db)
  puts db.execute("select name from sqlite_schema where type='table' and name not like 'sqlite_%'")
end

def is_integer?(num)
  num.delete(',').to_i.to_s == num
end