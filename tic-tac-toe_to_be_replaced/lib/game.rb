require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_accessor :player_one, :player_two, :current_player, :board
  def initialize(player_one, player_two)
    @player_one, @player_two = player_one, player_two
    @current_player = player_one
    @board = Board.new
  end

  def switch_players!
    @current_player = current_player == player_one ? player_two : player_one
  end

  def play_turn
    begin
      board.place_mark(current_player.get_move, current_player.mark)
    rescue StandardError => e
      puts e.message
      retry
    end
    switch_players!
    current_player.display(board)
  end

  def play
    current_player.display(board)
    play_turn until board.over?
    declare_winner
  end

  def declare_winner
    switch_players!
    current_player.display(board)
    if board.winner
      puts "Congratulations #{board.winner},\nYOU WIN!!!"
    else
      puts "Cats' game"
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new(HumanPlayer.new("Human", :O), ComputerPlayer.new("Computer", :X))
  game.play
end
