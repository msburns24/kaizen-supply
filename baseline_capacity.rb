require_relative "utils/msb_daru"
require_relative "utils/gsrcr_helpers"
require_relative "models/Models"

def get_baseline_capacity
  # Setup capacity DF with theoretical as starting DF
  theoretical_types = [:to_s, :to_s, :to_i]
  capacity = Daru::DataFrame.from_csv_with_types("data/theoretical_capacity.csv", types: theoretical_types).set_index("gpl_group")
  asp_gpl_types = [:to_s, :to_f]
  asp_gpl = Daru::DataFrame.from_csv_with_types("data/asp_gpl.csv", types: asp_gpl_types).set_index("gpl_group")
  capacity["ASP"] = asp_gpl["ASP"]
  capacity["theoretical"] = capacity["theoretical_units"] * capacity["ASP"]

  # Add in demonstrated from shipments_4w
  demonstrated = Daru::DataFrame.from_csv_with_types("data/shipments_4w.csv")
  value_fields = ["shipped_qty", "shipped_amt"]
  value_fields.each do |field|
    demonstrated[field] = demonstrated[field].map { |v| v.to_f } # Change shipped values to floats
  end

  # Join with gpl_groups, add to capacity DF
  material_number_gpl = Daru::DataFrame.from_csv_with_types("data/gpl_groups.csv")
  demonstrated = demonstrated.join(material_number_gpl, on: ["material_number"], how: :left)
  demonstrated["gpl_group"] = demonstrated["gpl_group"].map { |v| v.nil? ? "All Others" : v }
  capacity["demonstrated_4w"] = demonstrated.pivot_table(index: ["gpl_group"], agg: :sum)["shipped_amt"] / 4

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

def get_baseline_capacity_for(input_month)
  base_capacity = get_baseline_capacity.delete_vector("capacity_type")
  base_capacity.rename_vectors("baseline_capacity" => input_month)
  base_capacity[input_month] *= FiscalDates.weeks_per_month_for(input_month)

  return base_capacity
end