require 'byebug'

require_relative 'user'
require_relative 'ai_engine'

class TowersOfHanoi
  attr_reader :towers, :size
  def initialize(size = nil)
    @size = size.nil? ? 3 : size.to_i
    @towers = [[], [], []]
    @towers[0] = (1..@size).to_a.reverse
    @user = User.new(self)
  end

  def play
    render
    until won?
      from_tower, to_tower = @user.get_move
      puts(from_tower, "---", to_tower)
      next unless valid_move?(from_tower, to_tower)
      move(from_tower, to_tower)
      render
    end

    puts "CONGRATS !!!"
  end

  # private

  def auto_complete
    @user = Ai_engine.new(@towers)
    3
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
      (0...@towers.length).each do |tower|
        print "|" + ("==" * (@towers[tower][row] || 0)).center(115 / @towers.length) + "|"
      end
    end
    puts "\n\n"
  end
end

if __FILE__ == $0
  game = TowersOfHanoi.new(ARGV[0])
  game.play
end
