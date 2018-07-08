class Ship
  attr_accessor :size, :vertical, :pos
  alias_method :vertical?, :vertical

  def initialize(size, pos = nil, vertical = true)
    @size = size
    @pos = pos
    @vertical = vertical
  end
end
