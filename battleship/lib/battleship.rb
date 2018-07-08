require "colorize"
require "byebug"
require "yaml"
require_relative "board.rb"
require_relative "player.rb"
require_relative "human_player.rb"
require_relative "computer_player.rb"
require_relative "ship.rb"

class BattleshipGame
  SHIP_SIZES = [5, 4, 3, 3, 2]

  def self.load(filename = 'saved_game.txt')
    YAML.load(File.read(filename))
  end

  attr_reader :player, :opponent

  def initialize(player1, player2 = ComputerPlayer.new)
    @player, @opponent = player1, player2
  end

  def attack(pos)
    board[pos] = board[pos] == :s ? :h : :x
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
    play_turn until player.board.won?
    player.display(board)
  end

  def play_turn
    player.display(board.hide_ships)
    begin
      attack(player.get_play)
    rescue
      puts "try again"
      retry
    end
    player.display(player.board)

    switch_players
    save
  end

  def save(filename = 'saved_game.txt')
    File.open(filename, 'w') { |f| f.write(to_yaml) }
  end

  def set_up
    SHIP_SIZES.each do |size|
      begin
        ship = player.get_ship(size)
        player.board.place_ship(ship)
      rescue
        byebug
        retry
      end
    end
  end

  def switch_players
    @player, @opponent = @opponent, @player
  end
end

if $PROGRAM_NAME == __FILE__
  if ARGV[0] == 'load'
    game = BattleshipGame.load
  else
    game = BattleshipGame.new(HumanPlayer.new)
    game.set_up
    game.switch_players
    game.set_up
  end
  game.play
end
