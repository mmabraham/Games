require "colorize"
require_relative "./cursor.rb"

class Options
    attr_reader :grid, :prompt, :cursor

    def initialize(matrix, prompt = "")
        @grid = matrix
        @prompt = prompt
        @cursor = Cursor.new([0, 0], self);
    end

    def get_option
        while true
            render
            pos = cursor.get_input
            return self[pos] if pos
        end
    end

    def [](pos)
        row, col = pos
        grid[row][col]
    end

    private

    def render
        system('clear')
        puts prompt
        puts
        grid.each_with_index do |row, row_idx|
            row.each_with_index do |cell, col_idx|
            pos = [row_idx, col_idx]
            print format(pos), "      "
            end
            puts
        end
    end
    
    def format(pos)
        cell = self[pos]

        if pos == cursor.cursor_pos
            if cursor.selected
                cell.colorize(background: :light_yellow)
            else
                cell.colorize(background: :yellow)
            end
        else 
            cell
        end
    end
end