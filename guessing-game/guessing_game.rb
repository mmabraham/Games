def guessing_game
  target = rand(1..100)
  count = 1

  puts "guess a number"
  loop do
    guess = gets.chomp.to_i
    guess == target ? break : puts(guess)
    guess > target ? puts(" too high") : puts(" too low")

    count += 1
  end

  puts "You got it in #{count} guesses"
  puts target
end

def shuffle_file(input_path)
  input_arr = File.readlines(input_path)

  output_path = input_path.sub(".", "-shuffled.")
  File.open(output_path, "w") do |f|
    input_arr.shuffle.each { |line| f.puts(line) }
  end
end

if $PROGRAM_NAME == __FILE__
  ARGV.empty? ? guessing_game : shuffle_file(ARGV[0].chomp)
end
