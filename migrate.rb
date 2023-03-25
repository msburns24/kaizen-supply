require_relative "./lib/kaizen-data/migration.rb"

class CreatePCFByPartTable < KaizenData::Migration
  def self.migrate
    create_table "gpl_groups", {
      material_number: :string,
      gpl_group: :string
    }
  end
end


CreatePCFByPartTable.migrate()