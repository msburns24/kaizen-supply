require_relative "utils/msb_daru"
require_relative "date_summary"

def get_pcf_summary(quarters)
  # Convert quarter input to array if string
  quarters = [quarters] if quarters.is_a?(String)

  # Get dates information and filter for the quarter input
  dates = get_dates
  q3_months = dates.filter_rows { |row| quarters.include?(row["fiscal_quarter_label"]) }["fiscal_month_id"].to_a.uniq

  # Read in the PCF data for the quarter
  pcf_columns = "material_number,region,fiscal_month_id,PCF_amt,PCF_units".split(",")
  pcf_types = [:to_s, :to_s, :to_s, :to_f, :to_f]
  pcf_q3_raw = Daru::DataFrame.new({}, order: pcf_columns)

  q3_months.each do |month|
    pcf_q3_raw = pcf_q3_raw.concat(Daru::DataFrame.from_csv_with_types("data/PCF/PCF-#{month}.csv", types: pcf_types))
  end

  ###### Note:
  # At this point, the pcf_q3_raw is useful to summarize by gpl once joined with the gpl data.

  pcf_region_summary = pcf_q3_raw.pivot_table(index: ["region"], values: ["PCF_amt"], agg: :sum, margins: true)
  pcf_region_summary = pcf_region_summary.delete_vector("PCF_units")
  pcf_region_summary["PCF_amt"] = pcf_region_summary["PCF_amt"].map {|amt| amt.to_i}

  return pcf_region_summary
end