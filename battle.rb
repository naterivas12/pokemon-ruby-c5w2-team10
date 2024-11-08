require_relative "player"

class Battle
  # (complete parameters)
  attr_reader :player, :bot, :player_pkm, :bot_pkm

  def initialize(player, bot)
    # Complete this
    @player = player
    @bot = bot
    @player_pkm = player.pokemon
    @bot_pkm = bot.pokemon
  end

  def start
    header_battle
    # Prepare the Battle (print messages and prepare pokemons)
    print "#{player.name}'s #{player_pkm.name.capitalize} - "
    player_pkm.prepare_for_battle
    print "#{bot.name}'s #{bot_pkm.name.capitalize} - "
    bot_pkm.prepare_for_battle

    battle_loop

    winner = player_pkm.fainted? ? bot_pkm : player_pkm
    loser = winner == player_pkm ? bot_pkm : player_pkm
    # Check which player won and print messages
    # If the winner is the Player increase pokemon stats
    footer_battle(winner, loser)
    winner
  end

  def footer_battle(winner, loser)
    puts "#{winner.name.capitalize} WINS!"
    player_pkm.increase_stats(loser) if winner == player_pkm
    puts "#{'-' * 20}Battle Ended!#{'-' * 20}"
  end

  def header_battle
    puts "", "#{bot.name} sent out #{bot_pkm.name.upcase}"
    puts "#{player.name} sent out #{player_pkm.name.upcase}!"
    puts "#{'-' * 20}Battle Start!#{'-' * 20}"
    puts ""
  end

  def battle_loop
    # Until one pokemon faints
    # --Print Battle Status
    # --Both players select their moves
    # --Calculate which go first and which second
    # --First attack second
    # --If second is fainted, print fainted message
    # --If second not fainted, second attack first
    # --If first is fainted, print fainted message
    until player_pkm.fainted? || bot_pkm.fainted?
      player.select_move
      bot.select_move

      first = select_first(player_pkm, bot_pkm)
      second = first == player_pkm ? bot_pkm : player_pkm
      puts ""
      puts "-" * 52
      first.attack(second)
      puts "-" * 52
      unless second.fainted?
        second.attack(first)
        puts "-" * 52
      end
      ## print current stats (hp)
      fainted_messg(player_pkm, bot_pkm)
    end
  end

  def fainted_messg(*pokemons)
    pkm = pokemons.select(&:fainted?)
    if pkm.empty?
      print_current_hp
    else
      puts "#{pkm[0].name.capitalize} FAINTED!"
      puts "-" * 52
    end
  end

  def select_first(player_pkm, bot_pkm)
    # player_move = player_pkm.set_current_move
    # bot_move = player_pkm.set_current_move
    player_move = player_pkm.current_move
    bot_move = bot_pkm.current_move
    return player_pkm if player_move[:priority] > bot_move[:priority]
    return bot_pkm if player_move[:priority] < bot_move[:priority]
    return player_pkm if player_pkm.stats[:speed] > bot_pkm.stats[:speed]
    return bot_pkm if player_pkm.stats[:speed] < bot_pkm.stats[:speed]

    [player_pkm, bot_pkm].sample
  end

  def print_current_hp
    # player
    print "#{player.name}'s #{player_pkm.name.capitalize} - "
    puts " Level #{player_pkm.level}"
    puts "HP: #{player_pkm.current_hp}"
    # bot
    print "Random person's #{bot_pkm.name.capitalize} - "
    puts " Level #{bot_pkm.level}"
    puts "HP: #{bot_pkm.current_hp}"
  end
end

# battle = Battle.new("charmander", "onix")
# battle.start

# player = Player.new(name: "kissmark", pokemon: "Charmander", pokemon_name: "CharChar", level: 1)
# pp player14

# bot = Bot.new
# pp player15

# one_battle = Battle.new(player, bot)
# puts ("-" * 50).to_s
# one_battle.start
# player.pokemon.print_stats
