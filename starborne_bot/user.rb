require_relative 'db_initializer'


class User
  @@db = DbInitializer.instance.db

  def self.create(discord_username, discord_user_id)
    @@db.execute("INSERT OR IGNORE INTO Users (discord_user_id) VALUES (?)", 
                 [discord_user_id]
                )
    @@db.execute("Update Users 
                 SET discord_username = ?
                 WHERE discord_user_id = ?",
                 [discord_username, discord_user_id]
                )
  end

  def self.add_leader(discord_username, discord_user_id)
    @@db.execute("INSERT INTO Users (discord_username, discord_user_id, role) VALUES (?, ?, 'leader')", [discord_username, discord_user_id])
  end
  
  def self.promote(discord_username)
    @@db.execute("Update Users 
                 SET role = 'co-leader'
                 WHERE discord_username = ?",
                 [discord_username]
                )
  end

  def self.depromote(discord_username)
    @@db.execute("Update Users 
                 SET role = 'member'
                 WHERE discord_username = ?",
                 [discord_username]
                )
  end

  def self.pass_leadership(new_leader, current_leader)
    @@db.execute("Update Users 
                  SET role = 'leader'
                  WHERE discord_username = ?",
                 [new_leader]
                )
    @@db.execute("Update Users 
                  SET role = 'co-leader'
                  WHERE discord_username = ?",
                 [current_leader]
                )
  end

  def self.get_users
    users_array = @@db.execute("SELECT discord_username, role FROM Users") #[[discord_username, role]] / []

    users = []
    i = 0            
    users_array.length.times do           
      users << { username: users_array[i][0], role: users_array[i][1] }
      i += 1
    end
    
    users
  end

  def self.print_formatter(users)
    if users.empty?
      result = "There are no records of such users in database yet!"
      return result
    end
    i = 0
    line = "#{'-' * 55}\n"
    result = "#{line} USER#{'ROLE'.rjust(25)}\n #{line}"

    users.length.times do
      result += "#{users[i][:username]}#{users[i][:role].rjust(25)}\n"

      i += 1
    end

    result
  end

  def self.delete(discord_username)
    user_id = @@db.execute("SELECT id FROM Users WHERE discord_username = ?", [discord_username])

    @@db.execute("DELETE FROM Users WHERE id = ?", [user_id])
    @@db.execute("DELETE FROM Locations WHERE user_id = ?", [user_id])
    @@db.execute("DELETE FROM Reports WHERE user_id = ?", [user_id])
  end

  def self.check_role(discord_username)
    @@db.execute("SELECT role FROM Users WHERE discord_username = ?", [discord_username])[0][0] #[[role]]
  end

  def self.already_exists?(discord_username)
    @@db.execute("SELECT 0 from Users WHERE discord_username='#{discord_username}'")
        .length > 0
  end

  def self.not_exists?(discord_username)
    !already_exists?(discord_username)
  end

  def self.empty?
    @@db.execute("SELECT * FROM Users").empty?
  end
end