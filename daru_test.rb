require 'daru'

df = Daru::DataFrame.from_csv("./data/test-fmt.csv")

puts df.methods.sort.inspect