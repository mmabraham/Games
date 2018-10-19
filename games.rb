require "byebug"
require_relative './utils/options.rb'
require_relative './chess/chess.rb'
require_relative './minesweeper/minesweeper.rb'
require_relative './battleship/battleship.rb'
require_relative './towers-of-hanoi/towers_of_hanoi.rb'


def get_game
    game_name = Options.new([
        ["Chess"],
        ["Mine Sweeper"],
        ["Battleship"],
        ["Towers Of Hanoi"],
        ], "Select a game:").get_option
    system("clear")
    Object.const_get(game_name.gsub(" ", ""))::Game
end

def args(game)
    game.options.zip(game.prompts).map { |options, prompt| Options.new(options, prompt).get_option }
end


if __FILE__ == $PROGRAM_NAME
    game = get_game
    args = args(game)
    puts args
    game.init_with_options(*args)
end