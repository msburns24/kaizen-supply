require_relative "imports"

quarter = "FY23-Q3"

pcf = get_pcf_summary(quarter)
pcf[pcf.column_names.first] = pcf[pcf.column_names.first].map { |v| v/1000 }


summary = Daru::DataFrame.new({}, order: ["Amount"])
pcf.each_row_with_index do |row, index|
  summary.add_row(row.to_a, index)
end

# Summarize PCF and PDR commit
total_pcf = pcf[0].sum
summary.add_row([total_pcf], "Total")
pdr_commit = 6000
summary.add_row([pdr_commit], "PDR Commit")
total_pcf_pdr = total_pcf + pdr_commit
summary.add_row([total_pcf_pdr], "Total PCF + PDR")

# Subtract contraints
constraints = get_constraints(quarter)
total_gap = constraints["gap"].sum / 1000
summary.add_row([total_gap], "Constraints")
baseline_revenue = total_pcf_pdr + total_gap
summary.add_row([baseline_revenue], "Baseline Revenue")

# Add high-confidence actions
hc_actions = constraints.filter_rows { |row| row["confidence"] == "High" }["constr_vs_base"].sum / 1000
hc_actions = [hc_actions, -total_gap].min
summary.add_row([hc_actions], "High Confidence Actions")
constr_revenue = baseline_revenue + hc_actions
summary.add_row([constr_revenue], "Constrained Revenue")

# Prepare for display
# summary["Amount"] = summary["Amount"].map { |v| format_commas(v) }
summary.show