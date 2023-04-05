require_relative "../utils/msb_daru"
require_relative "../utils/gsrcr_helpers"
require_relative "ASPGPL"
require_relative "FiscalDates"

class Capacity < Daru::DataFrame

  def self.baseline_for_month(month)
    num_of_weeks = FiscalDates.weeks_per_month_for(month)
    df = baseline_weekly
    df["baseline_capacity"] *= num_of_weeks
    return df
  end
  
  def self.baseline_weekly
    # Setup capacity DF with theoretical as starting DF
    capacity = theoretical_weekly_amt
    capacity["demonstrated_4w"] = demonstrated_weekly["shipped_amt"]

    # Calculate baseline capacity
    capacity["baseline_capacity"] = 0
    capacity.each_row_with_index do |row, gpl|
      capacity["baseline_capacity"][gpl] = (
        capacity["capacity_type"][gpl] == "theoretical" ?
          capacity["theoretical"][gpl] :
          capacity["demonstrated_4w"][gpl]
      )
    end

    # Replace any nils with 0
    capacity["baseline_capacity"] = capacity["baseline_capacity"].map { |v| v.nil? ? 0 : v }

    return capacity["capacity_type","baseline_capacity"]
  end

  def self.theoretical_weekly_amt
    df = theoretical_weekly_units
    df["theoretical"] = df["theoretical_units"] * ASPGPL.get["ASP"]
    return df
  end

  def self.theoretical_weekly_units
    filename = "data/theoretical_capacity.csv"
    types = [:to_s, :to_s, :to_i]
    df = Daru::DataFrame.from_csv_with_types(filename, types: types)
    return df.set_index("gpl_group")
  end

  def self.demonstrated_weekly
    filename = "data/shipments_4w.csv"
    types = [:to_s, :to_s, :to_f, :to_f]
    df_raw = Daru::DataFrame.from_csv_with_types(filename, types: types)

    material_number_gpl = Daru::DataFrame.from_csv_with_types("data/gpl_groups.csv")
    df_raw = df_raw.join(material_number_gpl, on: ["material_number"], how: :left)
    df_raw["gpl_group"] = df_raw["gpl_group"].map { |v| v.nil? ? "All Others" : v }
    
    df = df_raw.pivot_table(index: ["gpl_group"], agg: :sum)
    df["shipped_amt"] /= 4
    df["shipped_qty"] /= 4
    
    return df
  end
end