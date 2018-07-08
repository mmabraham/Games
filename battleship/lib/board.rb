class Board
  attr_accessor :grid

  def self.default_grid
    Array.new(10) { Array.new(10) }
  end

  def initialize(grid = self.class.default_grid)
    @grid = grid
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    grid[row][col] = mark
  end

  def clone
    Board.new(grid.map { |row| row.clone } )
  end

  def count
    grid.flatten.count(:s)
  end

  def empty?(pos = nil)
    pos ? (pos.all? { |i| i < grid.size && i >= 0 } && self[pos].nil?) : won?
  end

  def find_all(sym)
    positions = []
    grid.each_with_index do |row, row_idx|
      row.each_with_index { |cell, col_idx| positions << [row_idx, col_idx] if cell == sym }
    end
    positions
  end

  def hide_ships
    hidden_board = clone
    find_all(:s).each { |pos| hidden_board[pos] = nil}
    hidden_board
  end

  def place_random_ship
    raise "board full" if full?
    pos = [rand(0...grid.size), rand(0...grid.size)]
    self[pos] = :s
  end

  def place_ship(ship)
    cell_line(ship.pos, ship.vertical?, ship.size).each { |cell| self[cell] = :s }
  end

  def won?
    count == 0
  end

  def cell_line(pos, vertical, size)
    vertical ? vertical_cells(pos, size) : horizonal_cells(pos, size)
  end

  def full?
    grid.flatten.all?
  end

  private
  def vertical_cells(pos, size)
    (pos.first...(pos.first + size)).map do |i|
      cell = [i, pos.last]
      raise "overlapping ships" unless empty?(cell)
      cell
    end
  end

  def horizonal_cells(pos, size)
    (pos.last...pos.last + size).map do |i|
      cell = [pos.first, i]
      raise "overlapping ships" unless empty?(cell)
      cell
    end
  end
end
