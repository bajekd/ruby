require 'rspec'

def palindrome?(str)
  str.downcase == str.downcase.reverse
end

describe ' Check if a word is a palindrome' do
  it ' returns true if the word is a palindrome, otherwise false' do
    expect(palindrome?('tacocat')).to be(true)
    expect(palindrome?('Tacocat')).to be(true)
    expect(palindrome?('baseball')).to be(false)
  end
end
