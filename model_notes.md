# Model Notes

```powershell
> kaizen generate model
```


`# kzs.ps1` - If first argument is generate, hand off to kzs_generate.ps1.

Give all arguments from 1 to end

```
# kzs_generate.ps1

If first argument is model:
	Return an error if no arguments after model.
	Otherwise:
	next argument is model name.
```

<br>

## Migrations

```powershell
> kaizen generate migration Example title:string posting_date:date qty:integer
```

```ruby
# Example rails migration
class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```

```ruby
# YYYYMMDDHHMMSS_CreateExampleTable
class CreateExampleTable < KaizenDataMigration
  def change
    create_table :example do |t|
      t["title"] = "string"
      t["posting_date"] = "date"
      t["qty"] = "integer"
    end
  end
end
```


To make a table:

```SQL
create table if not exists example (
  row_id integer primary key autoincrement,
  title string,
  posting_date date,
  qty integer
)
```