# require neccesary files
require_relative "pokedex/pokemons"
require_relative "pokedex/moves"
require_relative "pokemon_methods"

class Pokemon
  # include neccesary modules
  include Pokedex
  include PokemonMethods
  attr_reader :name, :species, :types, :base_exp, :effort_points, :growth_rate,
              :moves, :level, :base_stats, :individual_stats, :stats, :experience_points,
              :current_hp, :current_move, :effort_values

  # attr_writer :experience_points, :current_hp
  # attr_accessor :current_move

  # (complete parameters)
  # Retrieve pokemon info from Pokedex and set instance variables
  # Calculate Individual Values and store them in instance variable
  # Create instance variable with effort values. All set to 0
  # Store the level in instance variable
  # If level is 1, set experience points to 0 in instance variable.
  # If level is not 1, calculate the minimum experience point for that level and store it in instance variable.
  # Calculate pokemon stats and store them in instance variable
  def initialize(name: "", species: "random", level: 1)
    species = POKEMONS.keys[rand(POKEMONS.size)] if species == "random"
    pokemons = POKEMONS[species]
    @name = name.empty? ? species : name
    @species = pokemons[:species]
    @types = pokemons[:type]
    @base_exp = pokemons[:base_exp]
    @effort_points = pokemons[:effort_points]
    @growth_rate = pokemons[:growth_rate]
    @moves = pokemons[:moves]
    @level = level
    @base_stats = pokemons[:base_stats]
    @individual_stats = { hp: rand(32), attack: rand(32), defense: rand(32),
                          special_attack: rand(32), special_defense: rand(32),
                          speed: rand(32) }
    @effort_values = {  hp: 0, attack: 0, defense: 0, special_attack: 0,
                        special_defense: 0, speed: 0 }
    @stats = calculate_stats
    @experience_points = 0
    @current_move = nil
    @current_hp = stats[:hp]
  end

  private

  # Create here auxiliary methods

  def level?
    table = LEVEL_TABLES[growth_rate]
    # p table
    # p table[table.index { |min_xp| min_xp >= experience_points }]
    table.index { |min_xp| min_xp >= experience_points }
  end

  def calculate_stats
    stats = {}
    stats.store(:hp, calculate_hp)
    other_stats = base_stats.reject { |key| key == :hp }
    # p base_stats, individual_stats, effort_values
    other_stats.each_pair do |key, value|
      base = 2 * value
      effort = (effort_values[key] / 4).floor
      stat = (((base + individual_stats[key] + effort) * (level / 100.00)) + 5).floor
      stats.store(key, stat)
    end
    stats
  end

  def calculate_hp
    base = 2 * base_stats[:hp]
    effort = (effort_values[:hp] / 4).floor
    (((base + individual_stats[:hp] + effort) * (level / 100.00)) + level + 10).floor
  end

  def hits?(accuracy)
    accuracy >= rand(101)
  end

  def critical?
    rand(16) == 1
  end

  def calculate_damage(target, move)
    special = %i[fire water electric grass ice psychic dragon dark]
    offensive_stat = special.include?(move[:types]) ? stats[:special_attack] : stats[:attack]
    target_defensive_stat = special.include?(move[:types]) ? target.stats[:special_defense] : target.stats[:defense]
    target_defensive_stat *= 1.00
    lvl = (2 * level / 5.0)
    cal_stats = ((lvl + 2).floor * offensive_stat * move[:power] / target_defensive_stat).floor
    (cal_stats / 50.0).floor + 2
  end

  def special_move?(move)
    return false if move[:types] == :normal
  end

  def effectiveness(move, target)
    # -- Effectiveness check
    # -- Mutltiply damage by effectiveness multiplier and round down. Print message if neccesary
    # ---- "It's not very effective..." when effectivenes is less than or equal to 0.5
    # ---- "It's super effective!" when effectivenes is greater than or equal to 1.5
    # ---- "It doesn't affect [target name]!" when effectivenes is 0
    effect = TYPE_MULTIPLIER.select { |item| item[:user] == move[:type] }
    effect.select! { |item| target.types.any?(item[:target]) }
    # multiplier = effect.reduce { |acum, n| acum[:multiplier] * n[:multiplier] }
    multiplier = 1
    effect.each { |element| multiplier *= element[:multiplier] } unless effect.empty?
    effectiveness_messg(multiplier, target)
    multiplier
  end
end

def effectiveness_messg(multiplier, target)
  if multiplier <= 0.5
    puts "It's not very effective..."
  elsif multiplier >= 1.5
    puts "It's super effective!"
  elsif multiplier.zero?
    puts "It doesn't affect #{target.name}!"
  end
end
# pok = Pokemon.new(species: "Bulbasaur")
# pika = Pokemon.new(name: "Sauron", species: "Bulbasaur", level: 2)

# pok.experience_points = 7
# p pok.growth_rate
# p pok.experience_points
# p pok.level?
# p pok.level

# p pok.current_hp
# p pok.current_hp = 0
# p pok.fainted?

# 100.times do
#   p pok.hits?(100)
# end

# 16.times do
#   p pok.critical?
# end

# pp pok.types
# move = "vine whip"
# pika.current_move = move
# pika.attack(pok)

# pika.calculate_stats

# p pok.stats
# pok.increase_stats(pika)
# p pok.stats
