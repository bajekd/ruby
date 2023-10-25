require_relative 'db_initializer'

class Report
  @@db = DbInitializer.instance.db

  def self.create(report_content, discord_user_id, x, y)
    @@db.execute("INSERT INTO reports (content, user_id, date, coordinates_id) VALUES (
                 ?,
                 (SELECT id FROM Users WHERE discord_user_id = ?),
                 DATETIME('now'),
                 (SELECT id FROM Coordinates WHERE x_coordinate = ? AND y_coordinate = ?))",
                 [report_content, discord_user_id, x, y]
                ) #[[content, user_id, date, coordintates_id]] / []
  end

  def self.read(x, y)
    reports_array = @@db.execute("SELECT Reports.content, Users.discord_username, Reports.date FROM Reports 
                                 LEFT JOIN Users on Users.id = Reports.user_id
                                 WHERE coordinates_id = (SELECT id FROM Coordinates WHERE x_coordinate = ? AND y_coordinate = ?)
                                 ORDER BY date DESC
                                 LIMIT 5",
                                 [x, y]
                                ) #[[content, user_id, date, coordintates_id]] / []
            
    reports = []
    i = 0
    reports_array.length.times do           
      reports << { content: reports_array[i][0], author: reports_array[i][1], date: reports_array[i][2] }
      i += 1
    end 

    reports
  end

  def self.print_formatter(reports)
    if reports.empty?
      result = "There are no records of such location in database yet. Quickly tell spies that they have job to do!"
      return result
    end        
    
    result = ""
    line = "#{'-' * 55}\n"
    i = 0 
    reports.length.times do
      content = reports[i][:content]
      date = reports[i][:date]
      author = reports[i][:author]


      result += "Author: #{author.rjust(27)} \n Date (GMT): #{date.rjust(30)}\n\n"
      result += "#{content}\n"
      result += line
      i += 1
    end
                
    result
  end
end