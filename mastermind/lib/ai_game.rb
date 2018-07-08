class AiGame
  attr_accessor :possible_combinations

  def initialize
    @possible_combinations = %w(b y o r g p).repeated_permutation(4).map do |comb|
      Code.new(comb)
    end
    p possible_combinations.map {|c| c.pegs.join}.include?("bbbb")
  end

  def process_guess(guess_code, exact, near)
    possible_combinations.select! do |comb|
      guess_code.exact_matches(comb) == exact &&
        guess_code.near_matches(comb) == near
    end
  end

  def get_guess
    possible_combinations.sample
  end

  def play
    puts "pick a combination of 4 pegs (b/y/r/o/g/p) and write it down"
    puts "press enter to continue"
    gets
    play_turn while possible_combinations.length > 1
    puts "your code was #{possible_combinations.last.pegs}"
  end

  def play_turn
    guess = get_guess
    p guess.pegs
    puts "                              enter exact and near scores (x, x):"
    exact, near = gets.chomp.split(",").map(&:to_i)
    process_guess(guess, exact, near)
  end
end
