require 'byebug'

require_relative './lib/animation.rb'
require_relative './lib/human_player.rb'
require_relative './lib/computer_player.rb'

MAX_GUESSES = 7

module Hangman
  class Game
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

    def get_game_options
      puts "Welcome!\nWould you like to pick a word or guess one?"
      puts "Enter 'p' or 'g':"
      print "> "
      gets.downcase.chomp[0]
    end

    # For integration with the other games

    def self.options
      [
        [
          ["Pick a word"],
          ["Guess a word"]
        ]
      ]
    end
  
    def self.prompts
      ["--- Hangman ---"]
    end
  
    def self.init_with_options(game_type)
      if game_type[0].downcase == "p"
        Hangman::Game.new(guesser: ComputerPlayer.new, referee: HumanPlayer.new).play
      else
        Hangman::Game.new(guesser: HumanPlayer.new, referee: ComputerPlayer.new).play
      end
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = Hangman::Game.init_with_options(get_game_options)
end

# credit to Leland Krych for animation