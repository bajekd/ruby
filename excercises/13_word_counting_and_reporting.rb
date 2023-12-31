require 'rspec'

class String
  def total_words
    scan(/\w+/).count # same as self.scan(/\w+/).count
  end

  def word_counter
    counter = Hash.new(0)
    downcase.scan(/\w+/) { |w| counter[w] += 1 } # self.downcase.scan; scan method accept block of code

    counter
  end
end

describe 'Word Reporter' do
  before do
    @str = '- the quick brown fox / jumped over the lazy fox.'
  end

  it 'Counts word accurately' do
    expect(@str.total_words).to eq(9)
  end

  it 'Returns a hash that totals up word usage' do
    expect(@str.word_counter).to eq({ 'the' => 2,
                                      'quick' => 1,
                                      'brown' => 1,
                                      'fox' => 2,
                                      'jumped' => 1,
                                      'over' => 1,
                                      'lazy' => 1 })
  end
end
