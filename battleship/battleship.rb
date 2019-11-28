require "colorize"
require "byebug"
require "yaml"
require_relative "./lib/board.rb"
require_relative "./lib/player.rb"
require_relative "./lib/human_player.rb"
require_relative "./lib/computer_player.rb"
require_relative "./lib/ship.rb"
module Battleship
  class Game
    SHIP_SIZES = [5, 4, 3, 3, 2]

    def self.load(filename = 'saved_battleship_game.txt')
      YAML.load(File.read(filename))
    end

    attr_reader :player, :opponent

    def initialize(player1 = Battleship::HumanPlayer.new, player2 = Battleship::ComputerPlayer.new)
      @player, @opponent = player1, player2
    end

    def attack(pos)
      board[pos] = board[pos] == :s ? :h : :x
      print "\a" if board[pos] == :h
    end

    def board
      @opponent.board
    end

    def count
      board.count
    end

    def game_over?
      board.won?
    end

    def play
      player.display(board.hide_ships)
      switch_players
      player.display(board.hide_ships)
      play_turn until player.board.won?
      player.display(board)
    end

    def play_turn
      player.display(board.hide_ships)
      # begin
        attack(player.get_play)
      # rescue
      #   puts "try again"
      #   retry
      # end
      player.display(player.board)
      switch_players
      save
    end

    def save(filename = 'saved_battleship_game.txt')
      File.open(filename, 'w') { |f| f.write(to_yaml) }
    end

    def set_up
      SHIP_SIZES.each do |size|
        begin
          ship = player.get_ship(size)
          player.board.place_ship(ship)
        rescue
          retry
        end
      end
    end

    def switch_players
      @player, @opponent = @opponent, @player
    end

    # For integration with the other games

    def self.options
      [
        [
          ["Load Saved Game"],
          ["Start New Game"],
        ]
      ]
    end

    def self.prompts
      [
        "--- Battleship ---",
      ]
    end

    def self.init_with_options(option)
      if option == "Load Saved Game" || option == "load"
        game = Battleship::Game.load
      else 
        game = Battleship::Game.new
        game.set_up
        game.switch_players
        game.set_up
        game.switch_players
      end
      game.play
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Battleship::Game.init_with_options(ARGV[0])
end
