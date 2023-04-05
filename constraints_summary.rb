require_relative "utils/msb_daru"

def get_constraints(quarter)
  constraints_types = [:to_s, :to_s, :to_s, :to_i, :to_i, :to_i]
  constraints = Daru::DataFrame.from_csv_with_types("data/#{quarter}-constraints.csv", types: constraints_types)
  constraints = constraints.set_index("gpl")

  # Setup gaps
  constraints["gap"] = constraints["base_revenue"] - constraints["demand"]
  constraints["gap"] = constraints["gap"].map { |v| v > 0 ? 0 : v}
  # Fix unrealistic values
  constraints["gap"]["Engels"] = -3_000_000
  constraints["gap"]["All Others"] = -10_000_000

  # Setup constraints vs. base
  constraints["constr_vs_base"] = 0
  constraints.each_index do |gpl|
    constraints["constr_vs_base"][gpl] = [
      constraints["constr_revenue"][gpl] - constraints["demand"][gpl],
      constraints["constr_revenue"][gpl] - constraints["base_revenue"][gpl],
      0
    ].max
  end

  return constraints
end