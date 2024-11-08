module GetInput
  def ask_valid_input(*args)
    args.each_with_index { |value, index| print "#{index + 1}. #{value}    " }
    print "\n"
    input = ""
    until args.include?(input.capitalize)
      print "> "
      input = gets.chomp
    end
    input.capitalize
  end

  def input_not_empty
    input = ""
    while input.empty?
      print "> "
      input = gets.chomp
    end
    input
  end

  def get_with_options(prompt, options)
    puts ""
    input = ""
    puts prompt, ""
    print_options(options)
    until options.include?(input.downcase)
      print "> "
      input = gets.chomp
    end
    input.downcase
  end

  def print_options(options)
    options.each.with_index do |option, index|
      print "#{index + 1}. #{option.capitalize} #{' ' * 8}"
    end
    print "\n"
  end
end
