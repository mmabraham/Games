require 'byebug'

require_relative './lib/player'
require_relative './lib/computer_player'

module TowersOfHanoi
  class Game
    attr_reader :towers, :size
    def initialize(size = nil)
      @size = size.nil? ? 3 : size.to_i
      @towers = [[], [], []]
      @towers[0] = (1..@size).to_a.reverse
      @user = TowersOfHanoi::Player.new(self)
    end

    def play
      render
      until won?
        from_tower, to_tower = @user.get_move
        next unless valid_move?(from_tower, to_tower)
        move(from_tower, to_tower)
        render
      end

      puts "CONGRATS !!!"
    end

    # private
    def grid
      [ towers.map { [[""]]} ]
    end

    def auto_complete
      @user = TowersOfHanoi::ComputerPlayer.new(self)
      2
    end

    def move(from_tower, to_tower)
      @towers[to_tower] << @towers[from_tower].pop
    end

    def valid_move?(from_tower, to_tower)
      from_tower && to_tower &&
        @towers[from_tower] && @towers[to_tower] &&
        !@towers[from_tower].empty? &&
        (@towers[to_tower].empty? ||
        @towers[from_tower].last < @towers[to_tower].last)
    end

    def won?
      @towers[1..-1].any? { |tower| tower.size == @size }
    end

    def render
      system('clear')
      (@size -1).downto(0).each do |row|
        puts ""
        (0...@towers.length).each_with_index do |tower, tower_idx|
          border = @user.format("|", tower_idx)
          print border + ("==" * (@towers[tower][row] || 0)).center(115 / @towers.length) + border
        end
      end
      puts "\n\n"
    end

    # For integration with the other games

    def self.options
      [
        [
          ["3 ", "13"],
          ["4 ", "14"],
          ["5 ", "15"],
          ["6 ", "16"],
          ["7 ", "17"],
          ["8 ", "18"],
          ["9 ", "19"],
          ["10", "20"]
        ]
      ]
    end
  
    def self.prompts
      ["How many rings?"]
    end
  
    def self.init_with_options(num_rings)
      TowersOfHanoi::Game.new(num_rings.to_i).play
    end

    def self.player_type(type)
      case type
      when "Human Player"
        HumanPlayer
      when "DFS Bot"
        DFSPlayer
      when "BFS Bot"
        BFSPlayer
      end
    end
  end
end

if __FILE__ == $0
  TowersOfHanoi::Game.init_with_options(ARGV[0])
end
