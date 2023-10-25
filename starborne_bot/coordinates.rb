require_relative 'db_initializer'

class Coordinates
  @@db = DbInitializer.instance.db
  
  def self.create(x, y)
    @@db.execute("INSERT OR IGNORE INTO Coordinates (x_coordinate, y_coordinate) VALUES (
                 ?, ?)", x, y)
  end
end