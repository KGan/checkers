require_relative 'Board.rb'
require_relative 'Piece.rb'
require_relative 'exceptions.rb'
require_relative 'Player.rb'
require_relative 'Move.rb'
require 'colorize'
require 'io/console'
require 'yaml'
require 'byebug'

class Checkers

  def initialize(player1, player2)
    @players = [player1, player2]
    reset
  end

  def reset
    @turns = 0
    @board = Board.new
    @message = ""
    @current_player_color = nil
  end

  def run
    over = false
    show_hist = false
    display
    while !over
      player, other_p = @players[@turns % 2], @players[(@turns + 1) % 2]
      @message = "#{player.name} (#{player.color})'s turn to move"
      @current_player_color = player.color

      validity = false
      @turns += 1
      until validity
        input = player.get_move(@board)
        next if input.empty?
        validity = process(input)
      end
    end
  end

  def process(input)
    return false if input.nil?
    if input.first.is_a?(Array)
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
        display
        return true
      when 'history'
        toggle_history
      end
      return false
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
    move_seq = Move.to_move_array(move_seq)
    if @board.valid_move_sequence?(move_seq, true, @current_player_color)
      move_seq.each do |move|
        @board.make_move(move)
      end
      display
      true
    else
      false
    end
  end

  def display
    @board.display(@message)
  end

  def toggle_history
    @board.toggle_history
  end
end

class History
  attr_accessor :shown
  def initialize
    @history = []
    @shown = false
  end

  def record(move)
    @history.unshift [move.from, move.to]
  end

  def show_history
    return unless @shown
    @history[0..9].each_with_index do |moves, index|
      move_num = @history.size - index
      start = translate(moves.first)
      dest = translate(moves.last)
      c = movecolor(index)
      b = movecolor(index+1)
      print "#{move_num}|#{start}  #{dest}|\n".colorize(color: c, background: b)
    end
  end

  # def deep_dup
  #   new_h = History.new
  #   new_h.history = @history.deep_dup
  #   new_h
  # end

  private
  def movecolor(ind)
    ind.even? ? :white : :black
  end

  def translate(position)
    translated_pos = ""
    translated_pos += ('A'..'H').to_a[position.last]
    translated_pos += (7 - position.first).to_s
    translated_pos
  end


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
    p1 = Player.new(:red, :name => p1n)
    p2 = Player.new(:black, :name => p2n)
    g = Checkers.new(p1,p2)
    g.run
  end
end
