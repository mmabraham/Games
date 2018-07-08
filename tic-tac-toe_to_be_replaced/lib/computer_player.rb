class ComputerPlayer
  attr_accessor :name, :mark, :board
  def initialize(name, mark = nil)
    @name, @mark = name, mark
  end

  def get_move
    winning_pos(board) || random_pos(board)
  end

  def display(board)
    @board = board
  end

  private

  def random_pos(board)
    board.valid_moves.sample
  end

  def winning_pos(board)
    board.valid_moves.find { |pos| board.clone.place_mark(pos, mark).winner }
  end
end
