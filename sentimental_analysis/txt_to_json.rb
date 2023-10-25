require 'json'
require 'pry'

text_to_convert = []
words_txt = File.open("words.txt", "r")

  words_txt.each do |line| 
    text_to_convert << line
  end
words_txt.close()

text_to_convert = text_to_convert.map { |elem| elem.gsub("\t", ' ').gsub("\n", '').split(' ') }
                                 .map { |elem| elem[0], elem[1] = elem[1], elem[0] }
                                 .to_h
                                 .to_json

File.open("words.json", "a") { |f| f.write(text_to_convert) }