class Player
  NEXT_FLAG = {nil => :f, :f => :"?", :"?" => nil}

  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def display_board
    system('clear')
    puts header
    board.grid.each_with_index do |row, i|
      puts divider
      print " #{index(i)} |"
      puts row.map { |token| format(token) }.join + index(i)
    end
    puts divider
    puts header
  end

  def get_pos
    loop do
      $stdout.puts "Enter a position to sweep:"
      $stdout.puts "add 'F' to place flag"
      input = $stdin.gets
      pos = to_indices(input)
      next unless board.valid?(pos)
      next if flag_added?(input, pos)
      return pos
    end
  end

  def update(pos, mark)
    board[pos] = mark
  end

  private
  def flag_added?(input, pos)
    if input.downcase.include?("f") || board[pos] == :f || board[pos] == :"?"
      board[pos] = NEXT_FLAG[board[pos]]
      display_board
      true
    end
  end

  def format(token)
    "#{colorized(token)}|"
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
end
