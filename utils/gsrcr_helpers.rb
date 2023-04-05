# Method to setup a base df with GPLs as indeces
def setup_base_df
  gpls = Daru::DataFrame.from_csv_with_types("data/gpl_groups.csv")["gpl_group"].to_a.uniq.sort
  return Daru::DataFrame.new({}, index: gpls)
end