require 'date'

def create_migration(name)
  migration_name = name.split.map(&:capitalize).join

  template = <<~TEMPLATE
    class #{migration_name} < KaizenDataMigration
      def self.migrate
        create_table "pcf_by_part", {
          material_number: :string,
          fiscal_month: :string,
          pcf_amt: :integer,
          pcf_units: :integer
        }
      end
    end
  TEMPLATE
  
  timestamp = DateTime.now().strftime("%Y%m%d%H%M%S")
  
  filename = "#{timestamp}_#{name.split.map(&:capitalize).join}.rb"
  
  File.write(filename, template)
  
  puts "File '#{filename}' created."
end