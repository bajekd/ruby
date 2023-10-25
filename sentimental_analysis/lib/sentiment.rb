require 'pry'
require 'json'

module Sentiment
  class << self
    def call(text)
      sentiment = analyze(text, total=0)
      sentiment[:type] = sentiment_type(sentiment[:total])

      return sentiment
    end

    def analyze(text, total)
      total = 0
      word_bank = load_file("words.json")
      result = []

      words = clean(text).split()

      bigrams(text).each_with_index do |bigram, index|
        score = word_bank[bigram].to_f

        next if score == 0.0

        total +=score
        result << { bigram => total }

        2.times { words.delete(index) }
      end

      words.each do |word|
        score = word_bank[word].to_f #in case nil.to_f = 0 -> so lack of word in word_bank mean neutral word
        total += score

        result << { word => score }
      end
      { words: result, total: total }
    end

    def sentiment_type(total)
      case
      when total < -1
        'Extremely negative'
      when total >= -1 && total < -0.75
        'Strongly negative'
      when total >= -0.75 && total < -0.5
        'Clearly negative'
      when total >= -0.5 && total < -0.25
        'Moderately negative'
      when total >= -0.25 && total < 0
        'Rather negative'
      when total == 0
        'Neutral'
      when total > 0 && total <= 0.25
        'Rather positive'
      when total > 0.25 && total <= 0.5
        'Moderately positive'
      when total > 0.5 && total <= 0.75
        'Clearly positive'
      when total > 0.75 && total <= 1
        'Strongly positive'
      when total > 1
        'Extremely positive'
      end
    end

    def load_file(file_name)
      JSON.parse(File.read("#{Dir.pwd}/#{file_name}"))  # File.read("../#{file_name}")
    end

    def bigrams(text)
      bigram = text.split.each_cons(2).to_a
      bigram.map { |word| word.join(' ') }
    end

    def clean(text)
      replacements = %w(. , ? ! % ( ) { } [ ]).map { |char| text.gsub!(char, '') }

      return text.downcase()
    end
    
  end
end

puts("Enter text: ")
text = gets().chomp()
puts(Sentiment.call(text))