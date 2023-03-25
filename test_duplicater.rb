print "Enter a name for your system: "
system_name = gets.chomp

template = <<~TEMPLATE
  # #{system_name}.rb
  def #{system_name.tr(" ", "_")}
    puts "#{system_name.downcase}"
  end
TEMPLATE

filename = "#{system_name.downcase.tr(" ", "_")}.rb"

File.write(filename, template)

puts "File '#{filename}' created."
