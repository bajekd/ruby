require 'rspec'
require 'benchmark'

def new_max(arr)
  max_value = 0
  arr.each do |i|
    max_value = i if i > max_value
  end

  max_value
end

describe 'New Max method' do
  it 'returns the max value from an array' do
    test_array = [1, 5, 125, 6, 125, 3]
    expect(new_max(test_array)).to eq(125)
  end
end

# a = %w[albatross dog horse]
# a.max(2) {|a, b| a.length <=> b.length }  #=> ["albatross", "horse"]

arr = Array.new(10_000_000) { rand(10_000_000) }
Benchmark.bm(5) do |x|
  x.report('Sorted: ') { arr.sort.last }
  x.report('Each: ') { new_max(arr) }
  x.report('Max: ') { arr.max}
end