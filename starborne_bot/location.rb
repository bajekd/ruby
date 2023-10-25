require_relative 'db_initializer'
require 'pry'


class Location
  @@db = DbInitializer.instance.db

  def self.overlapping_locations(x, y) #Checking for potential overlapping bases
    potential_overlapping = @@db.execute("SELECT Coordinates.x_coordinate, Coordinates.y_coordinate, Locations.base_name, Users.discord_username
                                          FROM Coordinates 
                                          INNER JOIN Locations ON Locations.coordinates_id = Coordinates.id
                                          INNER JOIN Users ON Users.id = Locations.user_id
                                          WHERE x_coordinate BETWEEN ? - 10 AND ? + 10 
                                          AND 
                                          y_coordinate BETWEEN ? - 10 AND ? + 10",
                                          [x, x, y, y] ) #[[x, y, base_name, username]] / []
    reference_sum = x.to_i.abs + y.to_i.abs
    min_ref = reference_sum - 10
    max_ref = reference_sum + 10

    sums_to_compare = potential_overlapping.map { |elem| elem[0].abs + elem[1].abs }
    booleans = sums_to_compare.map { |sum| sum >= min_ref && sum <= max_ref ? true : false }

    i = 0
    indexes_of_overlapping = []
    booleans.length.times do
      indexes_of_overlapping << i if booleans[i] == true
      i += 1
    end

    overlapping_array =  indexes_of_overlapping.map { |index| potential_overlapping[index] } #[[x, y, base_name, username]] / []

    overlapping = []
    i = 0
    overlapping_array.length.times do
      overlapping << {user: overlapping_array[i][3], x: overlapping_array[i][0], y: overlapping_array[i][1], base: overlapping_array[i][2]}
      i += 1
    end

    overlapping
  end

  def self.overlapping?(x, y)
    overlapping_locatios(x, y).any?
  end

  def self.already_exists?(x, y)
    @@db.execute("SELECT 0 FROM Coordinates WHERE x_coordinate = ? AND y_coordinate = ?",
                 [x, y]
                ).any?
  end

  def self.not_exists?(x, y)
    !already_exists?(x, y)
  end

  def self.create(discord_username, x, y, base_name)
    @@db.execute("INSERT OR IGNORE INTO Locations (user_id, coordinates_id, base_name) VALUES (
                 (SELECT id FROM Users WHERE discord_username = '#{discord_username}'),
                 (SELECT id FROM Coordinates WHERE x_coordinate = ? AND y_coordinate = ?),
                 ?)", [x, y, base_name]
                )
  end

  def self.whose_location(x, y)
    locations_array = @@db.execute("SELECT Users.discord_username, Locations.base_name, Coordinates.x_coordinate, Coordinates.y_coordinate
                                   FROM Users
                                   LEFT JOIN Locations ON  Users.id = Locations.user_id
                                   LEFT JOIN Coordinates ON Locations.coordinates_id = Coordinates.id
                                   WHERE Coordinates.x_coordinate=#{x} AND Coordinates.y_coordinate=#{y}"
                                  ) #[[username, base_name, x, y]] / []
  
    locations = []   
    i = 0           
    locations_array.length.times do           
      locations << {user: locations_array[i][0], x: locations_array[i][2], y: locations_array[i][3], base: locations_array[i][1]}
      i += 1
    end 
    binding.pry
    locations
  end

  def self.get_locations(discord_username)
    locations_array = @@db.execute("SELECT Users.discord_username, Locations.base_name, Coordinates.x_coordinate, Coordinates.y_coordinate
                                   FROM Users
                                   INNER JOIN Locations ON Users.id = Locations.user_id
                                   INNER JOIN Coordinates ON Locations.coordinates_id = Coordinates.id
                                   WHERE Users.discord_username = '#{discord_username}'"
                                  ) #[[user_name, base_name, x, y]] / []

    locations = []   
    i = 0           
    locations_array.length.times do           
      locations << {user: locations_array[i][0], x: locations_array[i][2], y: locations_array[i][3], base: locations_array[i][1]}
      i += 1
    end 

    locations
  end

  def self.get_all_locations
    locations_array = @@db.execute("SELECT Users.discord_username, Locations.base_name, Coordinates.x_coordinate, Coordinates.y_coordinate
                 FROM Users
                 INNER JOIN Locations ON Users.id = Locations.user_id
                 INNER JOIN Coordinates ON Locations.coordinates_id = Coordinates.id"
                ) #[[user_name, base_name, x, y]] / []

    locations = []
    i = 0            
    locations_array.length.times do           
      locations << {user: locations_array[i][0], x: locations_array[i][2], y: locations_array[i][3], base: locations_array[i][1]}
      i += 1
    end
    
    locations
  end

  def self.delete(discord_username, x, y)
    coordinates_id = @@db.execute("SELECT id FROM Coordinates WHERE x_coordinate = ? AND y_coordinate = ?", [x, y])
    user_id = @@db.execute("SELECT id FROM Users WHERE discord_username = ?", [discord_username])

    @@db.execute("DELETE FROM Locations WHERE user_id = ? AND coordinates_id = ?", [user_id, coordinates_id])
  end

  def self.print_formatter(locations)
    if locations.empty?
      result = "There are no records of such locations in database yet!"
      return result
    end
    i = 0
    line = "#{'-' * 55}\n"
    result = "#{line} USER#{'X'.rjust(10)}#{'Y'.rjust(3)}#{'BASE'.rjust(25)}\n #{line}"

    locations.length.times do
      user_name = locations[i][:user]
      x = locations[i][:x].to_s
      y = locations[i][:y].to_s
      base_name = locations[i][:base].length > 25 ? locations[i][:base][0..21] + '...' : locations[i][:base]
      
      result += "#{user_name} #{x.rjust(10)}  #{y.rjust(3)}  #{base_name.rjust(25)}\n"

      i += 1
    end

    result
  end
end