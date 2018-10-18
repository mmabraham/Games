class MineSweeperCursor < Cursor
  def handle_key(key)
    return cursor_pos, true if key == :f
    return super, false
  end
end

class Player
  NEXT_FLAG = {nil => :f, :f => :"?", :"?" => nil}

  attr_reader :board, :cursor

  def initialize(board = MineSweeperBoard.new)
    @board = board
    @cursor = MineSweeperCursor.new([0, 0], board)
  end

  def display_board
    system('clear')
    puts header
    board.grid.each_with_index do |row, rowIdx|
      puts divider
      print " #{index(rowIdx)} |"
      puts row.map.with_index { |token, colIdx| format(token, [rowIdx, colIdx]) }.join + index(rowIdx)
    end
    puts divider
    puts header
  end

  def get_pos
    loop do
      $stdout.puts "Enter a position to sweep:"
      $stdout.puts "add 'F' to place flag"
      pos, flag_added = get_input
      next unless board.valid?(pos)
      next if has_flag?(pos, flag_added)
      return pos
    end
  end

  def update(pos, mark)
    board[pos] = mark
  end

  private
  def has_flag?(pos, flag_added)
    if flag_added || board[pos] == :f || board[pos] == :"?"
      board[pos] = NEXT_FLAG[board[pos]]
      display_board
      true
    end
  end

  def format(token, pos)
    cell = colorized(token)
    cell = cell.colorize(background: :light_yellow) if pos === cursor.cursor_pos
    "#{cell}|"
  end

  def index(i)
    i < 9 ? " #{i + 1}" : "#{i + 1}"
  end

  def to_indices(input)
    input.scan(/\d+/)[0,2].map { |str| str.to_i - 1}
  end

  def divider
    "    " + ("----" * board.width)
  end

  def colorized(token)
    case token
    when :"0" then "   "
    when :"1" then " 1 ".colorize(color: :light_blue)
    when :"2" then " 2 ".colorize(color: :green)
    when :"3" then " 3 ".colorize(color: :red)
    when :"4" then " 4 ".colorize(color: :blue)
    when :"5" then " 5 ".colorize(color: :blue)
    when :"6" then " 6 ".colorize(color: :blue)
    when :"7" then " 7 ".colorize(color: :blue)
    when :"8" then " 8 ".colorize(color: :blue)
    when :* then " * ".colorize(background: :red, color: :black)
    when :f then " F ".colorize(background: :yellow, color: :red)
    when :"?" then " ? ".colorize(background: :yellow, color: :red)
    else "   ".colorize(background: :blue)
    end
  end

  def header
    "     " + (0...board.width).map { |i| index(i) }.join("  ")
  end

  private

  def get_input
    while true
      display_board
      pos = cursor.get_input
      return pos if pos
    end
  end
end
