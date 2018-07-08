class Game
  attr_reader :secret_code
  def initialize(secret_code = Code.random)
    @secret_code = secret_code
  end

  def get_guess
    puts "Enter a code with the characters b/y/r/o/g/p:"
    Code.new($stdin.gets.chomp.chars)
  end

  def display_matches(code)
    $stdout.print("                    near:  ", secret_code.near_matches(code))
    $stdout.print("                    exact: ", secret_code.exact_matches(code),"\n")
    secret_code.exact_matches(code)
  end

  def attempt
    guess = get_guess
    display_matches(guess)
  end

  def play
    10.times do |count|
      if attempt == 4
        $stdout.puts "You got it in #{count + 1} guesses"
        exit
      end
    end
    puts "you lose"
  end
end
