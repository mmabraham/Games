require_relative "../../utils/cursor.rb";
require_relative "./player";

module Battleship
  class HumanPlayer < Battleship::Player
    def get_play
      while true
        system('clear')
        render(opponent_board);
        render(board, true);
        pos = cursor.get_input
        return pos if pos
      end
    end

    def get_ship(size)
      Ship.new(size, *get_pos_and_angle(size))
    end

    def display(opponent_board)
      super
      @cursor ||= Cursor.new([0, 0], opponent_board)
    end

    private
    def get_pos_and_angle(size)
      vertical = false
      system("clear")
      render(board, true)
      show_ship(size, vertical)

      print "'R' to rotate, any other key to continue:  "
      vertical = !vertical if gets.match(/[rR]/)
      
      system("clear")
      render(board, true)
      show_ship(size, vertical)
      pos = get_pos("enter row and column number to place this ship:")
      [pos, vertical]
    end

    def get_pos(prompt)
      puts(prompt)
      print "> "
      $stdin.gets.scan(/[0-9]/).map(&:to_i)
    end

    def show_ship(size, vertical = true)
      (size).times { vertical ? puts(colorized(:s)) : print(colorized(:s)) }
      puts ""
    end

    def render(board, own_board = false)
      puts header
      board.grid.each_with_index do |row, row_idx|
        puts divider
        print "  #{row_idx} |"
        puts row.map.with_index { |token, col_idx| format(token, [row_idx, col_idx], own_board) }.join
      end
      puts divider
    end

    def format(token, pos, own_board)

      cell = colorized(token)

      if !own_board && pos === cursor.cursor_pos
        cell = token == :h ? cell : cell.colorize(background: :light_yellow) 
      end

      "#{cell}|"
    end

    def colorized(token)
      case token
      when :x then " X ".colorize(color: :light_red)
      when :s then " S ".colorize(color: :light_white, background: :blue)
      when :h then " X ".colorize(color: :blue, background: :light_red)
      else "   "
      end
    end

    def divider
      "    " + ("----" * @board.grid.size)
    end

    def header
      "      " + (0...@board.grid.length).to_a.join("   ")
    end
  end
end