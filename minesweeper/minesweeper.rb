require 'colorize'
require 'byebug'
require_relative 'board.rb'
require_relative 'player.rb'

DEFAULT_MINES = 12
DEFAULT_HEIGHT = 10
DEFAULT_WIDTH = 10

class MineSweeperGame
  attr_reader :secret_board, :player, :mines, :height, :width

  def initialize(mines = DEFAULT_MINES, height = nil, width = nil)
    @mines, @height, @width = mines, height, width
    @secret_board = Board.new(height, width)
  end


  def play
    player.display_board
    take_turn until won?
    declare_win
  end

  def setup
    secret_board.place_random_mines(mines)
    secret_board.each_pos { |pos| secret_board[pos] = secret_board.score(pos).to_s.to_sym }
    @player = Player.new(Board.new(height, width))
  end

  private
  def declare_loss
    player.display_board
    puts "----   BOOM   ----"
    secret_board.each_pos do |pos|
      mark = secret_board[pos]
      player.update(pos, mark) if mark == :*
    end
    player.display_board
    exit
  end

  def declare_win
    Player.new(secret_board).display_board
    puts "You win !!!"
  end

  def reveal(pos)
    return if player.board[pos]

    player.update(pos, secret_board[pos])

    declare_loss if secret_board[pos] == :*
    if secret_board[pos] == :"0"
      player.board.adjacent_positions(pos).each { |pos| reveal(pos) }
    end
  end

  def take_turn
    # begin
      pos = player.get_pos
      reveal(pos)
      player.display_board
    # rescue
      $stdout.puts "try again"
      # retry
    # end
  end

  def won?
    cleared_cells = player.board.all_cells.count { |cell| cell && cell != :f && cell != :"?"}
    cleared_cells >= height * width - mines
  end
end

def prompt(str)
  $stdout.puts str
  $stdout.print "> "
  $stdin.gets.to_i
end

if $PROGRAM_NAME == __FILE__
  height = ARGV[0] || prompt("Please enter grid height:")
  width = ARGV[1] || prompt("Please enter grid width:")
  mines = ARGV[2] || prompt("Please enter number of mines to sweep:")

  game = MineSweeperGame.new(mines.to_i, height.to_i, width.to_i)
  game.setup
  game.play
end
