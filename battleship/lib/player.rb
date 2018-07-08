class Player
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def display(board)
    puts header
    board.grid.each_with_index do |row, i|
      puts divider
      print "  #{i} |"
      puts row.map { |token| format(token) }.join
    end
    puts divider
  end

  private
  def format(token)
    "#{colorized(token)}|"
  end

  def divider
    "    " + ("----" * @board.grid.size)
  end

  def colorized(token)
    case token
    when :x then " X ".colorize(color: :red)
    when :s then " S ".colorize(background: :blue)
    when :h then " X ".colorize(color: :red, background: :blue)
    else "   "
    end
  end

  def header
    "      " + (0...@board.grid.length).to_a.join("   ")
  end
end
