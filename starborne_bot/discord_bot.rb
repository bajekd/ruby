require 'pry'
require 'discordrb'
require_relative 'coordinates'
require_relative 'report'
require_relative 'user'
require_relative 'location'


class DiscordBot
  private_class_method :new
  @@instance = new

  def self.instance
    @@instance
  end

  def bot()
    @bot ||= Discordrb::Commands::CommandBot.new(token: "Njk5OTc0MTc1NDM1MjU5OTA0.XpjCSw.z06eKei_5RbR1V-3I839W-REYnA", #Don't worry I have already reseted my personal token. Cheers!
                                                 client_id: 699974175435259904,
                                                 prefix: '/',
                                                 command_doesnt_exist_message: command_doesnt_exist_message,
                                                )                                             
  end
  
  def reports_commands
    @bot.command(:save_report, description: description_save_report) do |event|
      command_content = event.message.content.delete_prefix('/save_report ')

      if command_content.empty?
        return event.respond("You don't provide any arguments! Type: `/help save_report` and check how `/save_report` command should be used.")
      end

      command_content = command_content.split("\n", 2)
      coordinates = command_content[0].scan(/-?\d+/)

      x = coordinates[0]
      y = coordinates[1]
      report_content = command_content[1]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil? || report_content.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help save_report` and check how `/save_report` command should be used.")
      end

      Coordinates.create(x, y)
      Report.create(report_content, discord_user[:discord_user_id], x, y)

      event.respond("Chill now, SNAFU.")
    end

    @bot.command(:get_reports, description: description_get_reports) do |event|
      command_content = event.message.content.delete_prefix('/get_reports')

      if command_content.empty?
        return event.respond("You don't provide any arguments! Type: `/help get_reports` and check how `/get_reports` command should be used.")
      end
      
      coordinates = command_content.scan(/-?\d+/)
      x = coordinates[0]
      y = coordinates[1]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help get_reports` and check how `/get_reports` command should be used.")
      end
      
      reports = Report.read(x, y)
      result = Report.print_formatter(reports)
      
      event.respond(result)
    end
  end
  
  def locations_commands
    @bot.command(:add_location, description: description_add_location) do |event|
      command_content = event.message.content.delete_prefix('/add_location ')

      if command_content.empty? 
        return event.respond("You don't provide any arguments! Type: `/help add_location` and check how `/add_location` command should be used.")
      end

      coordinates = command_content.scan(/-?\d+/)
      x = coordinates[0]
      y = coordinates[1]

      base_name = command_content.split(" ")[2]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil? || base_name.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help add_location` and check how `/add_location` command should be used.")
      end
    
      if Location.already_exists?(x, y)
        return event.respond("Somebody already have/have planned base in this place. To check whose this base is, type:"\
                             " `/whose_location X_COORDINATE Y_COORDINATE`")
      end
      
      Coordinates.create(x, y)
      Location.create(discord_user[:discord_username], x, y, base_name)

      event.respond("Your #{base_name} at location x: #{x}, y: #{y} has been added to database. Chill now, SNAFU.")
    end

    @bot.command(:whose_location, description: description_whose_location) do |event|
      command_content = event.message.content.delete_prefix('/whose_location ')

      if command_content.empty?
        return event.respond("You don't provide any arguments! Type: `/help whose_location` and check how `/whose_location` command should be used.")
      end

      coordinates = command_content.scan(/-?\d+/)
      x = coordinates[0]
      y = coordinates[1]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help whose_location` and check how `/whose_location` command should be used.")
      end

      if Location.not_exists?(x, y)
        return event.respond("In our database there are not any base at coordinates x: #{x} and y: #{y}")
      end

      location = Location.whose_location(x, y)
      result = Location.print_formatter(location)

      event.respond("#{result}")
    end

    @bot.command(:overlapping_locations, description: description_overlapping_locations) do |event|   
      command_content = event.message.content.delete_prefix('/overlapping_locations ')

      if command_content.empty?
        return event.respond("You don't provide any arguments! Type: `/help add_location` and check how `/add_location` command should be used.")
      end

      coordinates = command_content.scan(/-?\d+/) #to match all digits - negative and positive 
      x = coordinates[0]
      y = coordinates[1]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help add_location` and check how `/add_location` command should be used.")
      end

      locations = Location.overlapping_locations(x, y)
      result = Location.print_formatter(locations)
      
      event.respond(result)
    end

    @bot.command(:get_locations, description: description_get_locations) do |event|
      command_content = event.message.content.delete_prefix('/get_locations')
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      case command_content
      when ""
        author = event.message.author.username

        if User.not_exists?(author)
          return event.respond("You are not in database! First add yourself to db (see /help add_user)."\
                               " or add some your location to db (see /help add_location)."
                              )
        end

        locations = Location.get_locations(author)

      when /all/
        locations = Location.get_all_locations

      else #get list location for specific user
        username = command_content.strip.scan(/.+/)[0]

        if User.not_exists?(username)
          return event.respond("User you provide are not in database!")
        end

        locations = Location.get_locations(username)
      end
      
      result = Location.print_formatter(locations)

      event.respond(result)
    end

    @bot.command(:delete_location, description: description_delete_location) do |event|   
      command_content = event.message.content.delete_prefix('/delete_location ')

      if command_content.empty?
        return event.respond("You don't provide any arguments! Type: `/help delete_location` and check how `/delete_location` command should be used.")
      end

      coordinates = command_content.scan(/-?\d+/) #to match all digits - negative and positive 
      x = coordinates[0]
      y = coordinates[1]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      if x.nil? || y.nil?
        return event.respond("Something wrong with your sarguments! Type: `/help add_location` and check how `/add_location` command should be used.")
      end

      Location.delete(discord_user[:discord_username], x, y)
      
      event.respond("Please make sure if your location is removed from our database.")
    end
  end

  def users_commands
    @bot.command(:add_leader, description: description_add_leader) do |event|
      command_content = event.message.content.delete_prefix('/add_leader ')
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}

      if User.empty?
        User.add_leader(discord_user[:discord_username], discord_user[:discord_user_id])
        event.respond("#{discord_user[:discord_username]}, ave Imperator, morituri te salutant!")
      else
        event.respond("Can't perform operation - Users table is not empty!")
      end
    end

    @bot.command(:add_user, description: description_add_user) do |event|
      command_content = event.message.content.delete_prefix('/add_user ')
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s, role: 'member'}

      User.create(discord_user[:discord_username], discord_user[:discord_user_id])

      event.respond("#{discord_user[:discord_username]}, for the Emperor's name let none survive!")
    end

    @bot.command(:promote, description: description_promote) do |event|
      command_content = event.message.content.delete_prefix('/promote ')

      command_content = command_content.split(" ")
      username = command_content[0]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      User.create(discord_user[:discord_username], discord_user[:discord_user_id])
      discord_user[:role] = User.check_role(discord_user[:discord_username])

      if username.nil?
        return event.respond("Something wrong with your argument! Type: `/help promote` and check how `/promote` command should be used.")
      end

      if User.not_exists?(username)
        return event.respond("There are no such user in db as #{username}.")
      end

      if discord_user[:role] == 'member'
        return event.respond("#Only leader or co-leader can promote to co-leader")
      end

      User.promote(username)

      event.respond("#{username} successful promote to co-leader")
    end

    @bot.command(:depromote, description: description_depromote) do |event|
      command_content = event.message.content.delete_prefix('/depromote ')

      command_content = command_content.split(" ")
      username = command_content[0]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}
      username_role = User.check_role(username)

      User.create(discord_user[:discord_username], discord_user[:discord_user_id])
      discord_user[:role] = User.check_role(discord_user[:discord_username])

      if username.nil?
        return event.respond("Something wrong with your arguments! Type: `/help depromote` and check how `/depromote` command should be used.")
      end

      if User.not_exists?(username)
        return event.respond("There are no such user in db as #{username}.")
      end

      if discord_user[:role] == 'member'
        return event.respond("Only leader or co-leader can depromote!")
      end

      if username_role != 'co-leader'
        return event.respond("Only co-leader can be depromote! If you are leader the only way to depromote yourself is pass leadership to somebody else - check `/help pass_leadership`")
      end

      User.depromote(username)

      event.respond("#{username} successful depromote.")
    end

    @bot.command(:pass_leadership, description: description_pass_leadership) do |event|
      command_content = event.message.content.delete_prefix('/pass_leadership ')

      command_content = command_content.split(" ")
      username = command_content[0]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}

      User.create(discord_user[:discord_username], discord_user[:discord_user_id])
      discord_user[:role] = User.check_role(discord_user[:discord_username])

      if username.nil?
        return event.respond("Something wrong with your arguments! Type: `/help pass_leadership` and check how `/pass_leadership` command should be used.")
      end

      if User.not_exists?(username)
        return event.respond("There are no such user in db as #{username}.")
      end

      if discord_user[:role] != 'leader'
        return event.respond("Only leader can pass_leadership!")
      end

      User.pass_leadership(username, discord_user[:discord_username])

      event.respond("#{username} is our new leader! Ave!")
    end

    @bot.command(:get_users, description: description_get_users) do |event|
      command_content = event.message.content.delete_prefix('/get_users ')

      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}

      User.create(discord_user[:discord_username], discord_user[:discord_user_id])
      discord_user[:role] = User.check_role(discord_user[:discord_username])

      if discord_user[:role] == 'member'
        return event.respond("Only leader or co-leaders can perform this command!")
      end

      users = User.get_users
      result = User.print_formatter(users)

      event.respond("#{result}")
    end

    @bot.command(:delete_user, description: description_delete_user) do |event|
      command_content = event.message.content.delete_prefix('/delete_user ')

      command_content = command_content.split(" ")
      username = command_content[0]
      discord_user = {discord_username: event.message.author.username, discord_user_id: event.message.author.id.to_s}

      User.create(discord_user[:discord_username], discord_user[:discord_user_id])
      discord_user[:role] = User.check_role(discord_user[:discord_username])

      if User.not_exists?(username)
        return event.respond("There are no such user in db as #{username}.")
      end

      if discord_user[:role] == 'member'
        return event.respond("Only leader or co-leaders can perform this command!")
      end

      binding.pry
      User.delete_user(username)
      
      event.respond("Please make sure if pointed user is removed from our database.")
    end
  end

  def command_doesnt_exist_message
    "Don't know such command. Try again or type: `/help` to list all avaiable commands.\n"\
    " Type /help [command_name] to get help for specific command\n"\
    "Remember about `/` before every command!"
  end

  def description_save_report
    "\nSave spy report to database. You need to provide two things: coordinates - in first line (same line as command), report content"\
    " (in another line). Example: \n"\
    "```/save_report 200 300\n"\
    "report content goes here\n"\
    "...\n"\
    "oh boy, this report is really long```"\
    "If everything go alright bot should respond to you: `Chill now, SNAFU.`"
  end

  def description_get_reports
    "\nGet 5 latest spy reports from database in reverse  chronological order (i.e from newest to oldest) about given location. You need to provide one thing: 
    coordinates - in first line (same line as command). Example: \n"\
    "```/get_reports 200, 300```"\
    "If everything go alright bot should respond to you with reports content's"
  end

  def description_add_location
    "\nAdd base you have / will have with given coordinates to database. You need to provide two things: coordinates and base name"\
    "- both in first line (same line as command). Example: \n"\
    "```/add_location 200 300 example_base_1```"\
    "If everything go alright bot should respond to you: ```Your base: [base_name] at location x: [x], y: [y] has been added to database. Chill now, SNAFU.```"\
  end

  def description_whose_location
    "\nGet discord_username to whom belong / will belong base with given coordinates. You need to provide one thing: coordinates - "\
    " in first line (same as command). Example: \n"\
    "```/whose_location 200, 300```"\
    "If everything go alright bot should respond to you with appropriate informations"
  end

  def description_overlapping_locations
    "\nGet list of all overlapping locations. You need to provide one thing: coordinates - in first line (same line as command). Example: \n"\
    "```/overlapping_locations 200, 300```"\
    "If everything go alright bot should respond to you with appropriate informations."
  end

  def description_get_locations
    "\nGet list all of yours / given user / all users location(s). There are three variants of this command: \n"\
    "1)You provide nothing - it list all of your locations. Example: \n"\
    "```/get_locations```"\
    "--------------------------------------------\n"\
    "2) You need to provide one thing: discord username of person you want to check - in first line (same"\
    " line as command). Example: \n"\
    "```/get_locations some_discord_username```"\
    "--------------------------------------------\n"\
    "3)You need to provide one thing: keyword all - in first line (same"\
    " line as command). Example: \n"\
    "```/get_locations all```"\
    "--------------------------------------------\n"\
    "If everything go alright bot should respond to you with list of all user locations (or all users locations)."
  end

  def description_delete_location
    "\nDelete location with given coordinates. You need to provide two things: x and y - both in fist line (same line as command). Remember that you can only "\
    " delete location that belong to you (in other cases command won't work). Example: "\
    "``` /delete_location 100 250```"
    "If everything go alright bot should respond to you `Please make sure if your location is removed from our database.`"
  end 

  def description_add_leader
    "\nAdd leader guild to database. In order to work properly: 1) need to be done when Users table is empty 2) need to be done by guild leader"\
    " herself/himself. Example: \n"\
    "```/add_leader```"\
    "If everything go alright bot should respond to you `[your_discord_username], ave Imperator, morituri te salutant`."
  end

  def description_add_user
    "\nAdd yourself to database.Example: \n"\
    "```/add_user```"\
    "If everything go alright bot should respond to you `[your_user_name], for the Emperor's name let none survive!`."
  end

  def description_promote
    "\nPromote some member to co-leader. You need to provide one thing: discord_username - in first line (same as command). Remember that you need to be leader or co-leader"\
    " to perform this command. Example: \n"\
    "```/promote some_username```"\
    "If everything go alright bot should respond to you `[some_username] successful promote to co-leader`."
  end

  def description_depromote
    "\nDepromote some co-leader to member. You need to provide one thing: discord_username - in first line (same as command)."\
    " Remember that 1) only leader or co-leader can perform depromote 2) only co-leader can be depromote - if you are leader and you want to depromote yourself - "\
    " you need to pass leadership (type: `/help pass_leadership`)). Example: \n"\
    "```/depromote some_username```"\
    "If everything go alright bot should respond to you `[username] successful depromote.`"
  end

  def description_pass_leadership
    "\nPass leadership to some user. You need to provide one thing: discord_username - in first line (same as command)."\
    " Remember that 1) only leader can perfomr this command 2) after this operation you automatically will be degrade to co-leader. Example: \n"\
    "```/pass_leadership some_username```"\
    "If everything go alright bot should respond to you `[username] is our new leader! Ave!`."
  end

  def description_get_users
    "\nGet list of all users. Only leader or co-leaders can perform this command. Example: \n"\
    "```/get_users```"\
    "If everything go alright bot should respond to you with list of all users and their roles."
  end

  def description_delete_user
    "\nDelete given user and all related data (loations and reports). Only leader or co-leaders can perform this command Example: \n"\
    "```/delete_user some_username```"\
    "If everything go alright bot should respond to you `Please make sure if pointed user is removed from our database.`"
  end
end

#@bot.send_file(event.channel.id, File.open("locations.txt", 'r'))
