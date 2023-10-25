require 'rspec'
require 'byebug' # dunno why but in byebug you must escape ';' char

def sentence_reverser(str)
  translation_table_for_shift_to_left_chars = {
    ' ;' => ';',
    ' ,' => ',',
    ' .' => '.'
  }
  translation_table_for_shift_to_right_chars = {
    '! ' => '!'
  }

  # from: 'backwards am I, man; because I am big. Boosss!!!'
  # to: ["backwards", "am", "I", ",", "man", ";", "because", "I", "am", "big", ".", "Boosss", "!", "!","!"]
  array_str = str.gsub(/[;,!.]/, ' \0').split

  # from: ["backwards", "am", "I", ",", "man", ";", "because", "I", "am", "big", ".", "Boosss", "!", "!","!"]
  # to: '! ! ! Boosss . big am I because ; man , I am backwards'
  reverse_sentence = array_str.reverse.join(' ')

  # from: '! ! ! Boosss . big am I because ; man , I am backwards'
  # to: '! ! ! Boosss. big am I because; man, I am backwards'
  shift_chars_to_left = reverse_sentence.gsub(/\s[;,.]/, translation_table_for_shift_to_left_chars)
  shift_chars_to_right = shift_chars_to_left.gsub(/!\s/,
                                                  translation_table_for_shift_to_right_chars)
end

describe 'Sentence reverser' do
  it 'reverse words in sentence' do
    test_sentence = 'backwards am I, man; because I am big. Boosss!!!'

    expect(sentence_reverser(test_sentence))
      .to eq('!!!Boosss. big am I because; man, I am backwards')
  end
end
