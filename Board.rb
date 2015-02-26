class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    load_game(:new_game => true)
  end

  def [](array)
  end
  def []=(array, new_value)
  end

  def deep_dup

  end

  def load_game(**options)
    if options[:new_game]
      starting_board
    else
      load_board(options[:red], options[:black])
    end
  end

  def starting_board
  end
end
