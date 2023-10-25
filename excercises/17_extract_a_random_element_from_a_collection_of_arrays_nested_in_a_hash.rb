require 'rspec'
require 'byebug'

menu = {
  'appetizers': %w[Chips Quesadillas Flatbread],
  'entrees': %w[Steak Chicken Lobster],
  'dessers': %w[Cheescake Cake Cupcake]
}

def daily_special(hash)
  menu_items = []
  # category is i.e: 'appetizers': ['Chips', 'Quesadillas', 'Flatbread'],
  # category.first -> 'appetizers'
  # category.last -> '['Chips', 'Quesadillas', 'Flatbread']'
  # hash.map -> [%w[Chips Quesadillas Flatbread], %w[Steak Chicken Lobster], %w[Cheescake Cake Cupcake]]
  # has.map.flatten -> [ 9 elems].sample
  hash.map { |category| menu_items << category.last }.flatten.sample

  menu_items
end

def daily_meal(hash)
  meal = []
  # category is i.e: 'appetizers': ['Chips', 'Quesadillas', 'Flatbread'],
  # category.first -> 'appetizers'
  # category.last -> '['Chips', 'Quesadillas', 'Flatbread']'
  # category.last.flatten -> no effect, so still: ['Chips', 'Quesadillas', 'Flatbread']
  # category.last.flatten.sample (i.e) -> 'Chips'
  # meal (i.e) -> ['Chips', 'Chicken', 'Cake']
  hash.map { |category| meal << category.last.flatten.sample }
end

describe 'Nested hash element selector' do
  it 'selected a random element from the set of nested arrays' do
    expect(daily_special(menu).class).to eq(String)
  end
end
