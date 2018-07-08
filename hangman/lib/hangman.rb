require 'byebug'

require_relative 'animation.rb'
require_relative 'human_player.rb'
require_relative 'computer_player.rb'

MAX_GUESSES = 7

class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(options = {})
    @guesser = options[:guesser]
    @referee = options[:referee]
  end

  def play
    setup

    take_turn until won?
    referee.declare_winner(board)
  end

  def setup
    word_length = referee.pick_secret_word
    guesser.register_secret_length(word_length)
    @board = Array.new(word_length, nil)
  end

  def take_turn
    guess = guesser.guess(board)
    correct_indices = referee.check_guess(guess, board)
    update_board(correct_indices, guess)
    guesser.handle_response(guess, correct_indices)
  end

  private

  def update_board(indices, letter)
    indices.each { |i| board[i] = letter }
  end

  def won?
    board == board.compact || guesser.wrong_guesses.length > MAX_GUESSES
  end
end

def get_game_options
  puts "Welcome!\nWould you like to pick a word or guess one?"
  puts "Enter 'p' or 'g':"
  print "> "
  option = gets.downcase.chomp[0]
  if option == "p"
    { guesser: ComputerPlayer.new, referee: HumanPlayer.new }
  else
    { guesser: HumanPlayer.new, referee: ComputerPlayer.new }
  end
end

if $PROGRAM_NAME == __FILE__
  game = Hangman.new(get_game_options)
  game.play
end

# credit to Leland Krych for animation
