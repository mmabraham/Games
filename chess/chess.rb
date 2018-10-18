require_relative 'lib/board'
require_relative 'lib/display'
require_relative 'lib/pieces'
require_relative 'lib/players'

class Chess
  
  attr_reader :players, :board

  def initialize(player1, player2, board)
    @board = board
    @players = [player1, player2]
  end

  def play
    until board.game_over?(players.first.color)
      begin
        start_pos, end_pos = players.first.play_turn
        unless board[start_pos].color == players.first.color
          raise InvalidMoveError.new("Not your piece")
        end
        board.move_piece(start_pos, end_pos)
      rescue InvalidMoveError => error
        board.errors = error.message
        retry
      end

      switch_player!
    end
    players.last.display.render
    puts "#{players.last.name} wins!"
  end

  private

  def switch_player!
    players.rotate!
  end

    # For integration with the other games

    def self.options
      [
        [
          ["Human Player"],
          ["DFS Bot"],
          ["BFS Bot"]
        ], [
          ["Human Player"],
          ["DFS Bot"],
          ["BFS Bot"]
        ]
      ]
    end
  
    def self.prompts
      [
        "Please select the player for white",
        "Please select the player for black"
      ]
    end
  
    def self.init_with_options(white_name, black_name)
      board = ChessBoard.new
      display = Display.new(board)
      player1 = self.player_type(white_name).new(display, :white, white_name)
      player2 = self.player_type(black_name).new(display, :black, black_name)
      game = Chess.new(player1, player2, board)
      game.play
    end

    def self.player_type(type)
      case type
      when "Human Player"
        HumanPlayer
      when "DFS Bot"
        DFSPlayer
      when "BFS Bot"
        BFSPlayer
      end
    end
end

if __FILE__ == $PROGRAM_NAME
  board = ChessBoard.new
  display = Display.new(board)
  player1 = HumanPlayer.new(display, :white, "White")
  player2 = HumanPlayer.new(display, :black, "Black")
  player3 = BFSPlayer.new(display, :white, "BFS Bot")
  player4 = DFSPlayer.new(display, :black, "DFS Bot")

  if ARGV[0] == '-h'
    game = Chess.new(player1, player2, board)
  elsif ARGV[0] == '-c'
    game = Chess.new(player3, player4, board)
  else
    game = Chess.new(player1, player4, board)
  end
  game.play
end
