describe 'rspec'

def title_creator(title)
  heading = %w[h1 title_placeholder h1]
  heading[1] = title

  "<%s>%s</%s>"%(heading)
end

describe 'HTML h1 converter' do
  it 'outputs an h1 tag given a title' do
    expect(title_creator('A Big Boss')).to eq('<h1>A Big Boss</h1>')
  end
end
