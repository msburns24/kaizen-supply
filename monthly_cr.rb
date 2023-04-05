require_relative "utils/msb_daru"
require_relative "date_summary"
require_relative "pd_summary"
require_relative "utils/gsrcr_helpers"
require_relative "baseline_capacity"
require_relative "net_capacity"
require_relative "models/Models"
require_relative "utils/utils"

# Get months for rest of FY23 (FY23-Q3, FY23-Q4)
months = FiscalDates.months_array_for_quarters ["FY23-Q3", "FY23-Q4"]

# Setup starting past dues for first month
first_month = months.shift
pd_amt_start = setup_base_df
pd_amt_start[first_month] = get_starting_pds["past_due_amt"]
pd_amt_start[first_month] = pd_amt_start[first_month].map { |v| v.nil? ? 0 : v.to_i }

# PCF & Capacity
pcf_monthly = PCF.monthly_for(first_month)
baseline_capacity = Capacity.baseline_for_month(first_month)
net_capacity = get_net_capacity(first_month)

# Constr. Revenue
constr_revenue = setup_base_df
constr_revenue[first_month] = 0
constr_revenue.each_index do |gpl|
  begin
    gpl_pd_and_pcf = pd_amt_start[first_month][gpl] + pcf_monthly[first_month][gpl]
    gpl_net_capacity = net_capacity[first_month][gpl]
    constr_revenue[first_month][gpl] = [gpl_pd_and_pcf, gpl_net_capacity].min.to_i
  rescue IndexError
    constr_revenue[first_month][gpl] = 0
  end
end

# Ending past dues for first month
pd_amt_end = pd_amt_start.dup.rename("Ending Past Due Amt")
pd_amt_end[first_month] = pd_amt_end[first_month] + pcf_monthly[first_month] - net_capacity[first_month]
pd_amt_end[first_month] = pd_amt_end[first_month].map { |v| (v.nil? || v<0) ? 0 : v.to_i }

# loop through remaining months
months.each do |month|
  pd_amt_start[month] = pd_amt_end[-1]
  pcf_monthly[month] = PCF.monthly_for(month)[0]
  baseline_capacity[month] = Capacity.baseline_for_month(month)[0]
  net_capacity[month] = get_net_capacity(month)[0]

  # Constrained Revenue
  constr_revenue[month] = 0
  constr_revenue.each_index do |gpl|
    begin
      gpl_pd_and_pcf = pd_amt_start[month][gpl] + pcf_monthly[month][gpl]
      gpl_net_capacity = net_capacity[month][gpl]
      constr_revenue[month][gpl] = [gpl_pd_and_pcf, gpl_net_capacity].min.to_i
    rescue IndexError
      # Pass
    end
  end

  # Ending past due amt
  pd_amt_end[month] = pd_amt_start[month] + pcf_monthly[month] - net_capacity[month]
  pd_amt_end[month] = pd_amt_end[month].map { |v| (v.nil? || v<0) ? 0 : v.to_i }
end