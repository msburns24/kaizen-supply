require_relative "../utils/msb_daru"

class ASPGPL < Daru::DataFrame

  def self.get
    filename = "data/asp_gpl.csv"
    types = [:to_s, :to_f]
    df = Daru::DataFrame.from_csv_with_types(filename, types: types)
    return df.set_index("gpl_group")
  end
end