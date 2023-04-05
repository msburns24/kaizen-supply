require_relative "./utils/msb_daru"

def get_starting_pds
  # setup past dues
  pds_filename = "./data/past_dues.csv"
  pds_types = [:to_s, :to_s, :to_s, :to_f, :to_f]
  pds = Daru::DataFrame.from_csv_with_types(pds_filename, types: pds_types)
  snapshot_date = pds["snapshot_date"].to_a.uniq.sort.last
  pds = pds.rename("Past Dues from #{snapshot_date}")
  pds.delete_vector("snapshot_date")

  # setup gpl_groups
  gpl_groups_filename = "./data/gpl_groups.csv"
  gpl_groups_types = [:to_s, :to_s]
  gpl_groups = Daru::DataFrame.from_csv_with_types(gpl_groups_filename, types: gpl_groups_types)
  gpl_groups = gpl_groups.rename("GPL Groups")

  # Join past dues and gpl_groups
  pd_summary = pds.join(gpl_groups, on: ["material_number"], how: :left)

  pd_summary = pd_summary.pivot_table(index: ["gpl_group"], agg: :sum)
  pd_summary.delete_all_vectors_but("past_due_amt")

  return pd_summary
end