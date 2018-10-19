module Chess
  class NullPiece < Chess::Piece
    include Singleton

    def initialize
    end

    def value
      0
    end

    def symbol
      nil
    end
  end
end