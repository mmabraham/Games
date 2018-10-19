module Battleship
  class Player
    attr_accessor :opponent_board
    attr_reader :board, :cursor

    def initialize(board = Battleship::Board.new)
      @board = board
    end

    def display(board)
      self.opponent_board = board
    end
  end
end