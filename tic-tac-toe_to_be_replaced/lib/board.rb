class Board
  attr_accessor :grid
  def initialize(grid = nil, size = 3)
    @grid = grid || Array.new(size) { Array.new(size) }
    @size = size
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def place_mark(pos, mark)
    empty?(pos) ? self[pos] = mark : raise("box is occupied")
    self
  end

  def empty?(pos)
    self[pos].nil?
  end

  def over?
    grid.all?(&:all?) || winner
  end

  def winner
    won_on_rows? || won_on_columns? || won_on_left_diagonal? || won_on_right_diagonal?
  end

  def valid_moves
    (0...@size).to_a.repeated_permutation(2).select { |pos| empty?(pos) }
  end

  def clone
    cloned_rows = grid.map(&:dup)
    self.class.new(cloned_rows)
  end

  # private

  def won_on_rows?
    (0...@size).each do |i|
      row_positions = (0...@size).map { |j| [i, j] }
      return full?(row_positions) if full?(row_positions)
    end
    nil
  end

  def won_on_columns?
    inversed_board.won_on_rows?
  end

  def won_on_left_diagonal?
    positions = (0...@size).map { |i| [i, i] }
    full?(positions)
  end

  def won_on_right_diagonal?
    positions = (0...@size).map { |i| [i, (@size - 1) - i] }
    full?(positions)
  end

  def full?(positions)
    mark = self[positions.first]
    return mark if positions.all? { |pos| self[pos] == mark }
    nil
  end

  def inversed_board
    inversed_board = dup
    inversed_board.grid = grid.transpose
    inversed_board
  end

  def valid_move?(pos)
    valid_moves.include?(pos)
  end
end
