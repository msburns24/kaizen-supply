require_relative "utils/msb_daru"
require_relative "baseline_capacity"
require_relative "models/Models"

def get_net_capacity(month_input)
  # Import improvement_actions DF
  improvement_actions_types = [:to_s, :to_s, :to_s, :to_i]
  improvement_actions = Daru::DataFrame.from_csv_with_types("data/improvement_actions.csv", types: improvement_actions_types)

  # Setup capacity DF from baseline DF
  baseline_capacity = get_baseline_capacity

  # Convert improvement action target date to fiscal month id
  date_lookup = Daru::DataFrame.from_csv_with_types("data/dates.csv")
  date_lookup = date_lookup["date", "fiscal_month_id"]
  date_lookup.rename_vectors("date" => "target_date")
  improvement_actions = improvement_actions.join(date_lookup, on: ["target_date"], how: :inner)

  # Add a relative month id to the improvement actions DF
  months = Daru::DataFrame.from_csv_with_types("data/months.csv")
  improvement_actions = improvement_actions.join(months["fiscal_month_id", "rel_month_id"], on: ["fiscal_month_id"], how: :inner)

  # Setup a DF with the month input and the next 11 months
  rel_months = months["fiscal_month_id", "rel_month_id"].set_index("fiscal_month_id")
  weeks_per_month = months["fiscal_month_id", "weeks_per_month"].set_index("fiscal_month_id")
  weeks_per_input_month = weeks_per_month["weeks_per_month"][month_input]

  # Calculate total improvements
  month_input_rel_id = rel_months["rel_month_id"][month_input]
  baseline_capacity["improvements"] = 0
  baseline_capacity.each_index do |gpl|
    gpl_improvement_actions = improvement_actions.filter_rows do |row| 
      row["gpl_group"] == gpl && row["rel_month_id"] <= month_input_rel_id
    end
    total_improvements = gpl_improvement_actions["target_weekly_units"].sum || 0
    baseline_capacity["improvements"][gpl] = total_improvements
  end

  # Calculate net capacity, labelled same as fiscal month input.
  baseline_capacity[month_input] = baseline_capacity["baseline_capacity"]
  baseline_capacity.each_index do |gpl|
    if baseline_capacity["capacity_type"][gpl] == "demonstrated"
      baseline_capacity[month_input][gpl] = baseline_capacity["baseline_capacity"][gpl] + baseline_capacity["improvements"][gpl]
    end
  end

  output_vector = baseline_capacity[month_input] * FiscalDates.weeks_per_month_for(month_input)

  return output_vector.to_df.rename_vectors!("baseline_capacity" => month_input)
end

# month_input = "2023M7"
# get_net_capacity(month_input).show_head