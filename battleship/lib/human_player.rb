class HumanPlayer < Player
  def get_play
    get_pos("enter row and column number to attack:")
  end

  def get_ship(size)
    Ship.new(size, *get_pos_and_angle(size))
  end

  private
  def get_pos_and_angle(size)
    vertical = false
    display(board)
    show_ship(size, vertical)

    print "'R' to rotate, any other key to continue:  "
    vertical = !vertical if gets.match(/[rR]/)

    display(board)
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
end
