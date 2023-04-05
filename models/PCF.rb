require_relative "../utils/msb_daru"
require_relative "FiscalDates"
require_relative "GPLGroups"

class PCF < Daru::DataFrame

  def self.monthly_for(month)
    filename = "data/PCF/PCF-#{month}.csv"
    types = [:to_s, :to_s, :to_s, :to_f, :to_f]
    df_raw = Daru::DataFrame.from_csv_with_types(filename, types: types)

    df_raw = GPLGroups.join_with(df_raw)
    df = df_raw.pivot_table(index: ["gpl_group"], agg: :sum)
    df[month] = df["PCF_amt"]
    
    return df.delete_vector("PCF_amt").delete_vector("PCF_units")
  end
end