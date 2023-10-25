require 'rspec'

module CoreExtensions
  module String
    module Comments
      def commentize
        "# #{self}"
      end
    end
  end
end

class ContentController
  include CoreExtensions::String::Comments
  attr_reader :word

  def initialize(word)
    @word = word
  end

  def to_s
    word
  end
end


describe 'Include method from specific module' do
  it 'included commentize method to ContentController' do
    cc = ContentController.new('My String')
    expect(cc.commentize).to eq("# My String")
  end
end


