require 'daru'
require_relative "./print_table"
require_relative "./utils"

class Daru::DataFrame
  def self.from_csv_with_types(filename, opts = {})
    # Options: types, verbose

    print "Reading CSV..." if opts[:verbose]
    csv_data = CSV.read(filename)
    puts "Complete." if opts[:verbose]

    headers = csv_data.shift
    headers.map! { |hdr| hdr.gsub(/[\u200B-\u200D\uFEFF]/, '')}

    opts[:types] ||= [:to_s] * headers.length

    data_hash = {}
    headers.each { |h| data_hash[h] = []}

    row_count = csv_data.length

    print "Loading CSV into hash..." if opts[:verbose]
    (0..(row_count-1)).each do |i|
      row = csv_data[i].each_with_index.map { |val, i| val.send(opts[:types][i])} 
      headers.each_with_index { |h, i| data_hash[h] << row[i]}
    end
    puts "Complete." if opts[:verbose]

    print "Creating dataframe..." if opts[:verbose]
    df = Daru::DataFrame.new(data_hash)
    puts "Complete." if opts[:verbose]

    return df
  end

  def show
    puts KaizenTable.new(row_at(0..29))
  end

  def show_head
    puts KaizenTable.new(head)
  end

  def column_names
    vectors.to_a
  end

  def delete_all_vectors_but(vector_name)
    each do |v|
      delete_vector(v.name) unless v.name == vector_name
    end
  end
end