require 'CSV'
require 'sqlite3'
require_relative "./utils/utils.rb"

csv_filename = get_input("Enter CSV filename", Dir.glob("*.csv"))

# puts csv_filename

# hdrs = CSV.read("./sampledata/output-data.csv").first.map { |col| col.gsub(" ", "_").gsub(".", "").downcase }

# type_lookup = {
#   "T" => "TEXT",
#   "I" => "INTEGER",
#   "F" => "FLOAT",
#   "D" => "DATE"
# }

# puts "Enter data types for each column:"
# puts "T - Text"
# puts "I - Integer"
# puts "F - Float"
# puts "D - Date"
# puts "(blank) - Text"
# puts ""

# datatypes = {}
# hdrs.each do |col|
#   type_id = "undefined"
#   until "TIFD".split('').include?(type_id) || type_id == ""
#     printf "\r#{col}: "
#     type_id = gets.chomp.upcase
#   end
  
#   if type_id == ""
#     datatypes[col] = "TEXT"
#   else
#     datatypes[col] = type_lookup[type_id]
#   end
# end

# puts "\nPress any key to continue..."
# gets


# db_name = ""
# while db_name == ""
#   system "cls"
#   print("\rEnter database name: ")
#   db_name = gets.chomp.strip
# end

# confirm = ""
# valid_responses = ["Y", "N", "YES", "NO"]
# until valid_responses.include?(confirm)
#   system "cls"
#   print("\rCreate database '#{db_name}'? (y/n): ")
#   confirm = gets.chomp.strip.upcase
# end