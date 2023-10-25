require 'rspec'

class Hash
  def param_conventer
    map { |i| i * '=' } * '&'
  end
end

describe 'HTML Param Converter' do
  it 'Adds an HTML param conventer to the hash class' do
    hash = { topic: 'baseball', team: 'astros' }
    expect(hash.param_conventer).to eq('topic=baseball&team=astros')
  end
end

