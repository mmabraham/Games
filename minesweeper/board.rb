module MineSweeper
  class Board
    attr_reader :grid, :height, :width

    def initialize(height = nil, width = nil)
      @height = height || DEFAULT_HEIGHT
      @width = width || DEFAULT_WIDTH
      p @height, @width
      @grid = Array.new(@height) { Array.new(@width) }
    end

    def [](pos)
      row, col = pos
      grid[row][col]
    end

    def []=(pos, mark)
      row, col = pos
      grid[row][col] = mark
    end

    def adjacent_cells(pos)
      adjacent_positions(pos).map { |pos| self[pos] }
    end

    def adjacent_positions(pos)
      row, col = pos
      all_adjacent = [
        [row - 1, col - 1], [row - 1, col], [row - 1, col + 1],
        [row, col - 1],                     [row, col + 1],
        [row + 1, col - 1], [row + 1, col], [row + 1, col + 1]]
      only_valid(all_adjacent)
    end

    def each(&block)
      each_pos { |pos| block.call(self[pos]) }
    end

    def each_pos(&block)
      grid.each_with_index do |row, row_idx|
        row.each_index do |col_idx|
          block.call([row_idx, col_idx])
        end
      end
    end

    def full?
      all_cells.all? { |cell| cell }
    end

    def all_cells
      cells = []
      each { |cell| cells << cell }
      cells
    end

    def only_valid(positions)
      positions.select { |pos| valid?(pos) }
    end

    def place_random_mines(mines)
      mines.times { self[random_pos] = :* }
    end

    def random_pos
      [rand(0...height), rand(0...width)]
    end

    def score(pos)
      self[pos] == :* ? :* : adjacent_cells(pos).count(:*)
    end

    def valid?(pos)
      pos && pos.is_a?(Array) &&
      pos[0] && pos[1] &&
      pos[0] >= 0 && pos[0] < height && pos[1] >= 0 && pos[1] < width
    end
  end
end