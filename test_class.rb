class TestTable
  @@db_name = 'test.db'
  @@db = SQLite3::Database.open @@db_name
  @@table_name = "test_table"

  def self.all
    @@db.execute "select * from #{@@table_name}"
  end
end

p TestTable.all.class