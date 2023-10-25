require 'rspec'
require 'byebug'

headers = %w[
  1P
  2P
  3P
  4P
  5P
  6P
  7P
  8P
  9P
  10P
  11P
]

team_1 = %w[
  1_Player_1
  1_Player_2
  1_Player_3
  1_Player_4
  1_Player_5
  1_Player_6
  1_Player_7
  1_Player_8
  1_Player_9
  1_Player_10
  1_Player_11
]

team_2 = %w[
  2_Player_1
  2_Player_2
  2_Player_3
  2_Player_4
  2_Player_5
  2_Player_6
  2_Player_7
  2_Player_8
  2_Player_9
  2_Player_10
  2_Player_11
]

def position_filter(headers, *data)
  # headers.zip(data) --> pass all arrays as 1 big array
  # result: [["1P", ["1_Player_1", "1_Player_2", "1_Player_3", "1_Player_4", "1_Player_5", "1_Player_6", "1_Player_7", "1_Player_8", "1_Player_9", "1_Player_10", "1_Player_11"]], ["2P", ["2_Player_1", "2_Player_2", "2_Player_3", "2_Player_4", "2_Player_5", "2_Player_6", "2_Player_7", "2_Player_8", "2_Player_9", "2_Player_10", "2_Player_11"]], ["3P", nil], ["4P", nil], ["5P", nil], ["6P", nil], ["7P", nil], ["8P", nil], ["9P", nil], ["10P", nil], ["11P", nil]]

  # headers.zip(*data) -> pass all arays separately
  # [["1_Player_1", "1_Player_2", "1_Player_3", "1_Player_4", "1_Player_5", "1_Player_6", "1_Player_7", "1_Player_8", "1_Player_9", "1_Player_10", "1_Player_11"], ["2_Player_1", "2_Player_2", "2_Player_3", "2_Player_4", "2_Player_5", "2_Player_6", "2_Player_7", "2_Player_8", "2_Player_9", "2_Player_10", "2_Player_11"]]
  headers.zip(*data)
end

describe 'Position Filter' do
  it 'lines up players with their positions' do
    test_headers = %w[1P 2P 3P]
    test_team = ['First Player', 'Second Player', 'Third Player']

    expect(position_filter(test_headers, test_team)[1]).to eq(['2P', 'Second Player'])
  end
end

print position_filter(headers, team_1, team_2)
