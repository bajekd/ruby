require 'rspec'
require 'date'

years = (1900..1999).to_a
leap_years = []

# built-in approach
years.each do |year|
  leap_years << year if Date.new(year).leap?
end

describe 'Leap year calculation' do
  it 'properly renders the leap years for the 20th century' do
    expect(leap_years).to eq((1904..1999).step(4).to_a)
  end
end
