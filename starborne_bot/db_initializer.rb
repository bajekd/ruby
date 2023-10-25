require 'sqlite3'
require 'singleton'
require 'pry'

class DbInitializer
  include Singleton

  def db
    @db ||= SQLite3::Database::open('starborn.db')
  end
  
  def init
    db.execute("PRAGMA foreign_keys = ON")

    db.execute("CREATE TABLE IF NOT EXISTS Coordinates(
               id INTEGER PRIMARY KEY,
               x_coordinate INTEGER NOT NULL,
               y_coordinate INTEGER NOT NULL,
               UNIQUE(x_coordinate, y_coordinate));"
              )
    db.execute("CREATE TABLE IF NOT EXISTS Reports(
               id INTEGER PRIMARY KEY,
               content TEXT NOT NULL,
               date DATETIME NOT NULL,
               coordinates_id INTEGER,
               user_id INTEGER,
               FOREIGN KEY (coordinates_id) REFERENCES Coordinates(id),
               FOREIGN KEY (user_id) REFERENCES Users(id));"
              )
    db.execute("CREATE TABLE IF NOT EXISTS Users(
               id INTEGER PRIMARY KEY,
               discord_username TEXT,
               discord_user_id TEXT UNIQUE,
               role TEXT DEFAULT member);"
              )
    db.execute("CREATE TABLE IF NOT EXISTS Locations(
               id INTEGER PRIMARY KEY,
               base_name TEXT,
               user_id INTEGER,
               coordinates_id INTEGER UNIQUE,
               FOREIGN KEY (coordinates_id) REFERENCES Coordinates(id),
               FOREIGN KEY (user_id) REFERENCES Users(id));"
              )
  end
end