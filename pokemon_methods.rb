require_relative "pokedex/moves"

module PokemonMethods
  include Pokedex
  def print_stats
    puts "  HP: #{stats[:hp]}"
    puts "  Attack: #{stats[:attack]}"
    puts "  Defense: #{stats[:defense]}"
    puts "  Special Attack: #{stats[:special_attack]}"
    puts "  Special Defense: #{stats[:special_defense]}"
    puts "  Speed: #{stats[:speed]}"
    puts "  Experience Points: #{experience_points}"
  end

  def prepare_for_battle
    # @individual_stats
    @current_hp = stats[:hp]
    puts " Level #{level}"
    puts " HP: #{current_hp}"
  end

  def current_move=(move)
    @current_move = MOVES[move]
    # Complete this
  end

  def receive_damage(amount)
    if (current_hp - amount).negative?
      @current_hp = 0
    else
      @current_hp -= amount
    end
  end

  def fainted?
    current_hp < 1
  end

  def attack(target)
    # Print attack message 'Tortuguita used MOVE!'
    move = current_move
    puts "#{name.capitalize} used #{move[:name].upcase}!"
    # Accuracy check
    if hits?(move[:accuracy])
      # If the movement is not missed
      # -- Calculate base damage
      damage = calculate_damage(target, move)
      # -- Critical Hit check
      # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
      if critical?
        damage *= 1.5
        puts "It was CRITICAL hit!"
      end
      damage *= effectiveness(move, target)
      damage = damage.round
      # -- Inflict damage to target and print message "And it hit [target name] with [damage] damage""
      target.receive_damage(damage)
      puts "And it hit #{target.name.capitalize} with #{damage} damage"
    else
      # Else, print "But it MISSED!"
      puts "But it MISSED!"
    end
  end

  def increase_stats(target)
    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"
    points = target.effort_points
    @effort_values[points[:type]] += points[:amount]
    xp_gained = (target.base_exp * target.level / 7.0).floor
    puts "#{name.capitalize} gained #{xp_gained} experience points"
    @experience_points += xp_gained
    # If the new experience point are enough to level up, do it and print
    if level? > level
      @level = level?
      puts "#{name.capitalize} reached level #{level}!"
    end
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
    @stats = calculate_stats
  end
end
