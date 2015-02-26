require_relative 'Board.rb'
require_relative 'Piece.rb'
require_relative 'exceptions.rb'
require_relative 'Player.rb'
require_relative 'Move.rb'
require 'colorize'
require 'io/console'
require 'yaml'

class Checkers

  def initialize(player1, player2)
    @players = [player1, player2]
    reset
  end

  def reset
    @turns = 0
    @board = Board.new
  end

  def run
    over = false
    show_hist = false
    while !over
      player, other_p = @players[@turns % 2], @players[(@turns + 1) % 2]
      @message = "#{player.name}(#{player.color})'s turn to move"
      display

      validity = false
      until validity
        input = player.get_move(@board)
        validity = process(input)
      end
    end
  end

  def process(input)
    return false if input.nil?
    if input.first.is_a?(Move)
      try_moves(input)
    else
      case input.first
      when 'save'
        save_game
        puts "Continue playing (y,N)?"
        exit(0) unless gets.chomp.downcase == 'y'
      when 'reset'
        puts 'Are you sure you want to reset the game (y/N)?'
        reset if gets.chomp.downcase == 'y'
      when 'history'
        toggle_history
      end
      return true
    end
  end

  def save_game
    puts "what filename do you want to save as (default checkers.yml)?"
    filename = gets.chomp.gsub("\"", '')
    filename = 'checkers' if filename.length < 1
    filename += '.yml' unless /.yml/ =~ filename

    File.write(filename, YAML.dump(self))
  end

  def self.load_game
    puts "load from what file (default checkers.yml)?"
    filename = gets.chomp.gsub("\"", '')
    filename = 'checkers' if filename.length < 1
    filename += '.yml' unless /.yml/ =~ filename

    YAML::load_file(filename)
  end

  def try_moves(move_seq)

  end

  def display
    @board.display(message)
  end

end

class History
end



if __FILE__ == $PROGRAM_NAME
  puts "New(N) or Start from saved file(L)?"
  option = gets.chomp
  if /^l/=~ option.downcase
    g = Checkers.load_game
    g.run
  else
    puts "Player 1 name?"
    p1n = gets.chomp
    puts "Player 2 name?"
    p2n = gets.chomp
    p1 = Player.new(:white, p1n)
    p2 = Player.new(:black, p2n)
    g = Checkers.new(p1,p2)
    g.run
  end
end
