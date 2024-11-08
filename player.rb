# require neccesary files
require_relative "get_input"
require_relative "pokemon"
require_relative "pokedex/trainers"

# include pokedex
class Player
  # recibir de la entrada
  include GetInput
  include Pokedex
  attr_reader :name, :pokemon

  # (Complete parameters)
  def initialize(name: TRAINERS.sample, pokemon_name: "", pokemon: "random", level: 1)
    @name = name.capitalize
    @pokemon = Pokemon.new(name: pokemon_name, species: pokemon, level: level)
  end

  def select_move
    move = get_with_options("#{name}, select your move:", pokemon.moves)
    pokemon.current_move = move
    # Complete this
  end
end

# Create a class Bot that inherits from Player and override the select_move method
class Bot < Player
  def select_move
    move = pokemon.moves.sample
    pokemon.current_move = move
  end
end

# prueba = Player.new(name: "kissmark", pokemon: "Bulbasaur", pokemon_name: "zzz")
# pp prueba
# bot = Bot.new
# pp bot.select_move
# player1 = Player.new(name: "kissmark", pokemon: "Bulbasaur", pokemon_name: "zzz")
# p player1.select_move
# p player1.pokemon.current_move
