class User

  def initialize(game)
    @game = game
  end

  def get_move
    [get_index("move ring from tower number: "), get_index("move ring to towor number  : ")]
  end

  def get_index(prompt)
    puts prompt
    print "> "
    input = STDIN.gets.chomp
    @game.auto_complete if input == "help"
    input.to_i - 1
  end
end
