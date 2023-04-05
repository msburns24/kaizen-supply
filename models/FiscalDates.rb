require_relative "../utils/msb_daru"

class FiscalDates < Daru::DataFrame
  def self.weeks_per_month_for(input_month)
    months["weeks_per_month"][input_month].to_i
  end

  def self.months
    Daru::DataFrame.from_csv_with_types("data/months.csv").set_index("fiscal_month_id")
  end

  def self.months_array_for_quarters(quarters_array)
    filtered_months_df = months.filter_rows {|row| quarters_array.include?(row["fiscal_quarter_label"])}
    return filtered_months_df.index.to_a
  end
end