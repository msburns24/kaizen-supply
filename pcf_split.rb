require_relative "utils/msb_daru"

# 1. Load data into dataframe, clean data
types = [:to_s, :to_s, :to_s, :to_f, :to_f]
df = Daru::DataFrame.from_csv_with_types("./data/PCF.csv", types: types)

# 2. Extract months into array
months = df["fiscal_month_id"].to_a.uniq.sort

# 3. Loop through each month, filter dataframe, write to CSV
months.each do |month|
  print "Processing PCF-#{month}.csv\t"

  # Filter dataframe for that month
  df_month = df.filter_rows { |row| row["fiscal_month_id"] == month}

  # Open a new CSV
  csv = CSV.open("./data/PCF/PCF-#{month}.csv", "wb")

  # Write header line to CSV
  csv << df_month.column_names

  # For each row in filtered DF:
  df_month.each_row do |row|
    # Write that row to CSV
    csv << row.to_a
  end

  # Save CSV, go to next.
  csv.close
  puts "Complete."
end