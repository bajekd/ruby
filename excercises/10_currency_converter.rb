require 'rspec'


def currency_converter(amount, location)
  case location
  when 'US'
    "$%.2f"%(amount)
  when 'Japan'
    "¥%.0f"%(amount)
  when 'UK'
    ("£%.2f"%(amount)).gsub('.', ',')
  end
end

describe 'Currency converter' do
  it 'can properly format currency for US, Japan and UK' do
    expect(currency_converter(500, 'US')).to eq('$500.00')
    expect(currency_converter(500, 'Japan')).to eq('¥500')
    expect(currency_converter(500, 'UK')).to eq('£500,00')
  end
end
