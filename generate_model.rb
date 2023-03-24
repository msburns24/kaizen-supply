migration_data = {
  table_name: "example",
  columns: [
    # I'll need to check for the null.nil? if not it will be confusing
    # e.g. "not_null" = true    <-- This is confusing. Avoid this syntax.
    {name: "id", type: "integer", primary_key: true, null: false, 
      foreign_key: false, autoincrement: true},
    
    # Can leave off unneeded keys. Will check if they are there, if not
    # will go to default.
    {name: "title", type: "string", null: false},
    {name: "posting_date", type: "date", null: false},
    {name: "qty", type: "date", null: false, default: 0}
  ]
}

defaults = {
  primary_key: false,
  autoincrement: false,
  unique: false,
  default: "NULL",
  null: true,
}

# Need to validate information inputted is correct.

# Need to add a primary key if it isn't already there

column_array = []
migration_data.columns.each do |col|
  column_item = ""
  column_item += "#{col.name} #{col.type.upcase}"
  column_item += " PRIMARY KEY" if col.primary_key
  column_item += " NOT NULL" if (!col.null.nil? && !col.null)
  column_item += " UNIQUE" if (col.unique)
  column_item += " AUTOINCREMENT" if (col.autoincrement)
  column_item += " FOREIGN KEY" if (col.foreign_key)

  column_array << column_item
end

column_info = column_array.join(",\n")

db.execute("CREATE TABLE IF NOT EXISTS #{table_name} (
  #{column_info}
  )"
)