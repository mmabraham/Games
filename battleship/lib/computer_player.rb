class ComputerPlayer < Player
  def display(board)
    @opponent_board = board

    # uncomment to display computer_player board for debugging
    # super
  end

  def get_play
    return ship_ends.sample unless ship_ends.empty?
    return empty_cells_next_to(single_hits).sample unless empty_cells_next_to(single_hits).empty?
    random_pos
  end

  def get_ship(size)
    Ship.new(size, *get_pos_and_angle(size))
  end

  private

  def adjacent_cells(pos)
    row, col = pos
    [[row, col + 1], [row, col - 1], [row + 1, col], [row - 1, col]]
  end

  def empty_cells_next_to(hit_arr)
    cells = []
    hit_arr.each { |hit_pos| cells += adjacent_cells(hit_pos) }
    empty_only(cells)
  end

  def double_hits
    result = []
    hits.combination(2).each do |pos1, pos2|
      result += [pos1, pos2] if adjacent_cells(pos1).include?(pos2)
    end
    result
  end

  def empty_only(cells)
    cells.select { |cell| @opponent_board.empty?(cell) }
  end

  def ends(pos1, pos2)
    [next_after(pos1, pos2), next_after(pos2, pos1)]
  end

  def get_pos_and_angle(size)
    loop do
      vertical = [true, false].sample
      pos = vertical ? [rand(0..9 - size), rand(0..9)] : [rand(0..9), rand(0..9 - size)]
      return [pos, vertical] if board.cell_line(pos, vertical, size).all? { |cell| board.empty?(cell) }
    end
  end

  def hits
    @opponent_board.find_all(:h)
  end

  def next_after(pos1, pos2)
    rows = [pos1.first, pos2.first]
    cols = [pos1.last, pos2.last]
    [rows.last + (rows.last - rows.first), cols.last + (cols.last - cols.first)]
  end

  def random_pos
    loop do
      pos = [rand(0..9), rand(0..9)]
      return pos if @opponent_board.empty?(pos)
    end
  end

  def ship_ends
    targets = []
    double_hits.each_cons(2) do |hit1, hit2|
      ends(hit1, hit2).each { |target| targets << target if @opponent_board.empty?(target) }
    end
    targets
  end

  def single_hits
    hits.reject { |hit| double_hits.include?(hit) }
  end
end
