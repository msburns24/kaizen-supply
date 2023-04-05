require_relative "../utils/msb_daru"
require_relative "FiscalDates"

class GPLGroups < Daru::DataFrame

  def self.join_with(df)
    filename = "data/gpl_groups.csv"
    gpl_groups = Daru::DataFrame.from_csv_with_types(filename)
    df = df.join(gpl_groups, on: ["material_number"], how: :left)
    df["gpl_group"] = df["gpl_group"].map { |gpl| gpl.nil? ? "All Others" : gpl }
    return df
  end
end