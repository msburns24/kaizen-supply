require_relative "./utils/msb_daru"

def get_dates
  # Open dates file
  filename = "./data/dates.csv"
  dates = Daru::DataFrame.from_csv_with_types(filename)
  columns = dates.column_names

  dates = dates.uniq(columns[1..]).delete_vector(columns.shift)

  new_index_array = (0..(dates.size-1)).to_a
  dates["new_index_col"] = Daru::Vector.new new_index_array, index: new_index_array.map { |i| 7*i }
  dates.set_index("new_index_col")

  return dates
end