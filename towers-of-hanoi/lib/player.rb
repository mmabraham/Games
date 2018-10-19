
require 'colorize'
require_relative '../../utils/cursor.rb'

module TowersOfHanoi
  class TowersOfHanoiCursor < Cursor
    def handle_key(key)
      return cursor_pos, true if key == :f
      return super, false
    end
  end

  class Player
    attr_reader :cursor, :game
    attr_accessor :selected_pos
    def initialize(game)
      @game = game
      @cursor = TowersOfHanoiCursor.new([0, 0], game)
    end

    def get_move
      [get_index, get_index]
    end

    def get_index
      while true
        game.render
        puts "Enter - F - and - \u2B90 - to finish auto-magically"
        pos, cheating = cursor.get_input
        return game.auto_complete if cheating
        return pos[1] if pos
      end
    end

    def format(border, tower_idx)
      if tower_idx == cursor.cursor_pos[1]
        if cursor.selected
          border.colorize(background: :light_yellow)
        else
          border.colorize(background: :yellow)
        end
      else
        border.colorize(background: :default)
      end
    end
  end
end