require_relative "utils/msb_daru"
require_relative "utils/gsrcr_helpers"

pcf_raw_types = [:to_s, :to_s, :to_s, :to_f, :to_f]
pcf_raw = Daru::DataFrame.from_csv_with_types("data/PCF/PCF-2023M7.csv", types: pcf_raw_types)
pcf_raw = pcf_raw.concat Daru::DataFrame.from_csv_with_types("data/PCF/PCF-2023M8.csv", types: pcf_raw_types)
pcf_raw = pcf_raw.concat Daru::DataFrame.from_csv_with_types("data/PCF/PCF-2023M9.csv", types: pcf_raw_types)
material_number_gpl = Daru::DataFrame.from_csv_with_types("data/gpl_groups.csv")
pcf_raw = pcf_raw.join(material_number_gpl, on: ["material_number"], how: :left)
pcf_raw["gpl_group"] = pcf_raw["gpl_group"].map { |v| v.nil? ? "All Others" : v }

pcf = pcf_raw.pivot_table index: ["gpl_group"], values: ["PCF_amt"], agg: :sum
pcf["ASP"] = pcf["PCF_amt"] / pcf["PCF_units"]
pcf.delete_vector("PCF_amt")
pcf.delete_vector("PCF_units")

output_csv = CSV.open("data/asp_gpl.csv", "wb")
columns = pcf.column_names.unshift("gpl_group")

output_csv << columns
pcf.each_row_with_index do |row, gpl|
  output_csv << [gpl].concat(row.to_a)
end

output_csv.close