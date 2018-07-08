class Code
  PEGS = {0 => "b", 1 => "y", 2 => "o", 3 => "r", 4 => "g", 5 => "p"}

  attr_reader :pegs

  def self.parse(peg_str)
    pegs = peg_str.downcase.chars
    raise "invalid colors" unless pegs.all? { |char| PEGS.has_value?(char) }
    new(pegs)
  end

  def self.random
    pegs = []
    4.times { pegs << PEGS[rand(0..5)] }
    new(pegs)
  end

  def initialize(pegs)
    @pegs = pegs
  end

  def [](i)
    pegs[i]
  end

  def ==(code)
    code.is_a?(Code) && pegs == code.pegs
  end

  def exact_matches(code)
    count = 0
    pegs.each_with_index { |peg, i| count += 1 if peg == code[i] }
    count
  end

  def near_matches(code)
    marked_arr = code.pegs.dup
    pegs.each do |peg|
      match_index = marked_arr.index(peg)
      marked_arr[match_index] = "X" if match_index
    end
    marked_arr.count("X") - exact_matches(code)
  end
end
