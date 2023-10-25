require 'rspec'

def random_numbers(n)
  Array.new(n) { rand(1_001) } # Array may take block code
  # Array.new(n) do
  #   rand(1_000_000)
  # end
end

describe 'Random number collection generator' do
  it 'create a collection of random numbers ranging from 1 to 1000' do
    random_set_one = random_numbers(10)
    random_set_two = random_numbers(100)

    expect(random_set_one.count).to eq(100)
    expect(random_set_two.count).to eq(1000)

    expect(random_set_one[0..99]).to_not eq(random_set_two[0..99])
  end
end
