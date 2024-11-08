# require neccesary files
require_relative "player"
require_relative "greetings"
require_relative "get_input"
require_relative "battle"

# Create a welcome method(s) to get the name, pokemon and pokemon_name from the user
# Then create a Player with that information and store it in @player
class Game
  include Greetings
  include GetInput
  attr_reader :player

  def start
    args = welcome
    @player = Player.new(args)
    action = menu
    until action == "Exit"
      case action
      when "Train"
        train
        action = menu
      when "Leader"
        challenge_leader
        action = menu
      when "Stats"
        show_stats
        action = menu
      else
        print "> "
        action = gets.chomp.capitalize
      end
    end
    goodbye
  end

  def welcome
    hello
    puts "First, what is your name?"
    name = input_not_empty
    choose_pokemon(name)
    pokemon = ask_valid_input("Bulbasaur", "Charmander", "Squirtle")
    puts "", "You selected #{pokemon.upcase}. Great choice!", "Give your pokemon a name?"
    pokemon_name = input_not_empty
    puts "", "#{name.upcase}, raise your young #{pokemon_name.upcase} by making it fight!"
    puts "When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
    { name: name, pokemon: pokemon, pokemon_name: pokemon_name }
  end

  def train
    bot = Bot.new(level: rand(1..player.pokemon.level))
    puts "", "#{player.name} challenge #{bot.name} for training"
    puts "#{bot.name} has a #{bot.pokemon.species} level #{bot.pokemon.level}"
    puts "What do you want to do now?", ""
    action = ask_valid_input("Fight", "Leave")
    battle = Battle.new(player, bot)
    battle.start if action == "Fight"
  end

  def challenge_leader
    bot = Bot.new(name: "Brock", pokemon: "Onix", pokemon_name: "Steelix", level: 10)
    puts "", "#{player.name} challenge the Gym Leader #{bot.name} for a fight!"
    puts "#{bot.name} has a #{bot.pokemon.species} level #{bot.pokemon.level}"
    puts "What do you want to do now?", ""
    action = ask_valid_input("Fight", "Leave")
    battle = Battle.new(player, bot)
    winner = battle.start if action == "Fight"
    puts "Congratulation! You have won the game!" if winner == player.pokemon
    puts "You can continue training your Pokemon if you want" if winner == player.pokemon
  end

  def show_stats
    puts "", "#{player.pokemon.name.capitalize}:"
    puts "  Kind: #{player.pokemon.species}"
    puts "  Level: #{player.pokemon.level}"
    puts "  Type: #{player.pokemon.types.join(', ')}"
    puts "Stats:"
    player.pokemon.print_stats
  end

  def menu
    puts "", "-------------------------Menu-------------------------", ""
    puts "1. Stats        2. Train        3. Leader       4. Exit  "
    print "> "
    gets.chomp.capitalize
  end
end

game = Game.new
game.start
