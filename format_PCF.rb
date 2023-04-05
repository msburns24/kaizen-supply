require 'roo'

filename = "./data/test-fmt.xlsx"

xlsx = Roo::Spreadsheet.open(filename)

# loop through each row of the first sheet
xlsx.sheet(0).each_row_streaming do |row|
  row
end


# ps_path = "C:/Users/msb/OneDrive/programming/powershell_applets/ForceRemove.ps1"
# system("powershell.exe -ExecutionPolicy Bypass -File #{ps_path} #{path}")