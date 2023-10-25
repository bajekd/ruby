require 'rspec'

def increment_value(str)
  str + str.next.slice(-1) # 'abc'.next = 'abd'; 'abd'.slice(-1) = 'd'; .next = .succ
end

describe 'Increment string valule sequence' do
  it 'appends the next item in sequence of a string' do
    expect(increment_value('abcde')).to eq('abcdef')
    expect(increment_value('1234')).to eq('12345')
  end
end
