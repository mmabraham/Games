
module TowersOfHanoi
  class ComputerPlayer
    def initialize(game)
      @game = game
      @towers = game.towers
      @moves = []
    end

    def get_move
      sleep(0.2)
      @moves << target_move if @moves.empty?
      @moves << add_next_move(@moves.last) until valid?(@moves.last)
      move = @moves.pop
      @game.render
      [move.from, move.to]
    end

    def format(border, _)
      border.colorize(background: :default)
    end

    private

    def add_next_move(last_move)
      return clear_higher_rings(last_move) if stuck?(last_move)
      clear_target_tower(last_move) if blocked?(last_move)
    end

    def target_move
      widest_tower_idx = (0..1).max_by { |tower_idx| @towers[tower_idx][0] || 0 }
      Move.new(widest_tower_idx, 0, 2)
    end

    def blocked?(move)
      from_tower = @towers[move.from]
      target_tower = @towers[move.to]

      return false if target_tower.empty?
      target_tower.last < from_tower[move.ring]
    end

    def stuck?(move)
      @towers[move.from][move.ring + 1]
    end

    def clear_higher_rings(move)
      Move.new(move.from, move.ring + 1, third_tower(move.from, move.to))
    end

    def clear_target_tower(move)
      rings_at_target = @towers[move.to]
      lowest_obsticle_ring_size = rings_at_target.find { |ring| ring < @towers[move.from][move.ring] }
      lowest_obsticle_ring_idx = rings_at_target.index(lowest_obsticle_ring_size)
      Move.new(move.to, lowest_obsticle_ring_idx, third_tower(move.to, move.from))
    end

    def third_tower(tower1, tower2)
      tower_indices = (0..2).to_a
      tower_indices.delete_if { |tower_idx| [tower1, tower2].include?(tower_idx) }.last
    end

    def valid?(move)
      @towers[move.from][move.ring] &&
        @towers[move.from][move.ring] == @towers[move.from].last &&
        (@towers[move.to].empty? ||
        @towers[move.from].last < @towers[move.to].last)
    end
  end

  Move = Struct.new(:from, :ring, :to)
end