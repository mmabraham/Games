require 'colorize'
require_relative '../../utils/cursor.rb'

module Hangman
  Board = Struct.new(:grid)
  class HumanPlayer
    attr_reader :wrong_guesses, :cursor
    def initialize(*args)
      @wrong_guesses = []
    end
    
    def declare_winner(board)
      if board.length == board.compact.length
        puts "I Win!"
        puts
        puts "your word was: #{board.join.colorize(color: :red)}"
        puts
      else
        puts "You Win!"
      end
    end
    
    def check_guess(guess, board)
      @cursor ||= Cursor.new([0, 0], Board.new([board, []]))
      @message = "Please select all spaces with the letter: #{guess.upcase.colorize(color: :green)}
      hit 'done' when complete"

      @selected_indices = []
      while true
        index = get_index(board, true)
        break if index == true
        @selected_indices << index
      end
      wrong_guesses << guess if @selected_indices.empty?
      @selected_indices
    end

    def guess(board)
      display(board)
      puts
      puts wrong_guesses
        .map { |char| " #{char} ".colorize(color: :light_yellow, background: :blue) }
        .join(" ".colorize(background: :default))
      puts
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
    def display(board, cursor_enabled = false)
      system('clear')
      puts ANIMATION[wrong_guesses.count]
      puts
      puts @message
      puts
      if board
        board.each_with_index do |letter, idx|
          cell = letter ? letter.colorize(color: :blue) : " _ ".colorize(color: :light_red)
          cell = format(cell, idx) if cursor_enabled
          print(cell)
        end
      end
      puts "\n"
      puts format(" done ".colorize(background: :blue, color: :light_yellow), "bottom") if cursor_enabled
    end

    def format(cell, idx)
      if idx == "bottom" && cursor.cursor_pos[0] == 1
        return cell.colorize(background: :light_yellow, color: :blue)
      elsif idx == cursor.cursor_pos[1] && cursor.cursor_pos[0] == 0
        return cell.colorize(background: :light_yellow)
      elsif @selected_indices.include?(idx)
        return cell.colorize(background: :yellow)
      end
      cell
    end

    def get_index(board, cursor_enabled)
      while true
        display(board, cursor_enabled)
        row_idx, idx = cursor.get_input
        return true if row_idx == 1
        return idx if idx
      end
    end
  end
end