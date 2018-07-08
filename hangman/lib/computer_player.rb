
class ComputerPlayer
  attr_reader :dictionary, :board, :candidate_words, :wrong_guesses

  def initialize(dictionary = nil)
    @dictionary = dictionary || File.readlines("lib/dictionary.txt")
    @dictionary.map! { |word| word.chomp.strip }
    @candidate_words = @dictionary
    @wrong_guesses = []
  end

  def check_guess(guess, _board = nil)
    indices = []
    @secret_word.each_char.with_index { |letter, i| indices << i if letter == guess }
    indices
  end

  def declare_winner(board)
    board.join == @secret_word ? puts("You win!!!") : puts("You lose")
    puts "The word was: #{@secret_word}"
    exit
  end

  def guess(board)
    remaining_letters = candidate_words.join.delete(board.join).chars
    if remaining_letters.empty?
      puts "\nI dunno what your word is but it aint in MY dictionary\n"
      exit
    end
    ("a".."z").max_by { |letter| remaining_letters.count(letter) }
  end

  def handle_response(letter, indices)
    if indices.empty?
      wrong_guesses << letter
      candidate_words.reject! { |word| word.include?(letter) }
    else
      candidate_words.select! do |word|
        indices.all? { |i| word[i] == letter } && indices.count == word.count(letter)
      end
    end
  end

  def pick_secret_word
    @secret_word = dictionary.sample
    @secret_word.length
  end

  def register_secret_length(length)
    @board = Array.new(length, nil)
    candidate_words.select! { |word| word.length == length }
  end
end
