require 'pry'
require_relative 'db_initializer'
require_relative 'discord_bot'

DbInitializer.instance.init

bot = DiscordBot.instance.bot
DiscordBot.instance.reports_commands
DiscordBot.instance.locations_commands
DiscordBot.instance.users_commands
bot.run


=begin
bot.message(contains: 'Ping!') do |event| #with_text / contain / contains /starts_with / ends_with --> https://repl.it/talk/learn/Making-a-Discord-bot-in-Ruby/8427
  event.respond 'Pong!'
end
=end