class HumanPlayer
  attr_accessor :name, :mark
  def initialize(name, mark = nil)
    @name, @mark = name, mark
  end

  def get_move
    puts "where would you like to move?  (x, x)"
    print "> "
    gets.chomp.split(",").map(&:to_i)
  end

  def display(board)
    system('clear')
    puts "\n\n\n        0    1    2  \n"
    board.grid.each_with_index do |row, i|
      puts "      +---++---++---+"
      print "    #{i} "
      row.each { |box| print "| #{box || ' '} |" }
      puts ""
    end
    puts "      +---++---++---+"
    puts "\n\n"
  end
end
