#!/usr/bin/env ruby

require_relative 'game.rb'
require_relative 'code.rb'
require_relative 'ai_game.rb'

if $PROGRAM_NAME == __FILE__
  puts "would you like to pick a code or guess? p / g"
  game = gets.chomp == "p" ? AiGame.new : Game.new
  game.play
end
