require 'terminal-table'

class KaizenTable

  def initialize(df)
    @table = Terminal::Table.new do |t|
      t.title = df.name if df.name
      
      t.headings = [""].concat(df.column_names)
      df.each_row_with_index do |row, index|
        t.add_row [index].concat(row.to_a)
      end

      t.add_row ["..."] * df.column_names.length if df.size >= 30
    end
  end

  def to_s
    @table.to_s
  end
end