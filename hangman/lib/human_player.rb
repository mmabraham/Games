class HumanPlayer
  attr_reader :wrong_guesses
  def initialize(*args)
    @wrong_guesses = []
  end

  def declare_winner(board)
    if board.length == board.compact.length
      puts "Yeeha! That's what I'm talking about"
      puts "your word was: #{board.join}"
    else
      puts "You beat me"
    end
  end

  def check_guess(guess, board)
    display(board)
    puts "Please enter indexes with the letter: #{guess.upcase}"
    puts "ie: '0, 3, 5'"
    print "> "
    indices = gets.chomp.split(",").map(&:to_i)
    wrong_guesses << guess if indices.empty?
    indices
  end

  def guess(board)
    display(board)
    puts wrong_guesses.join(" ")
    puts "Please guess a letter"
    print "> "
    gets.chomp[0]
  end

  def handle_response(letter, indices)
    wrong_guesses << letter if indices.empty?
  end

  def pick_secret_word
    puts "Please pick a secret_word"
    puts "You may enter the word or just the number of letters in it"
    print ">"
    input = gets.chomp
    input.to_i == 0 ? input.length : input.to_i
  end

  def register_secret_length(length)
    @board = Array.new(length, nil)
  end

  private
  def display(board)
    puts ANIMATION[wrong_guesses.count]
    puts "\n"
    board.each { |letter| print(letter ? letter : " _ ") } if board
    puts "\n"
  end
end
