class Board
  attr_accessor :cursor
  CURSOR_DIRECTIONS = {
    :up     => [-1,  0],
    :down   => [ 1,  0],
    :left   => [ 0, -1],
    :right  => [ 0,  1]
  }
  def initialize
    @pieces_count = {
      :red => 12, :black => 12
    }
    @cursor = [7,0]
    @highlighted = []
    @grid = Array.new(8) { Array.new(8) }
    load_game(:new_game => true)
  end
# cursor functions
  def move_cursor(direction)
    @cursor = Move.add(@cursor, CURSOR_DIRECTIONS[direction])
  end

  def highlight(pos)
    @highlighted << @cursor
  end

  def reset_selection
    @highlighted = []
  end
# grid accessors
  def [](pos)
    @grid[pos.first][pos.last] if in_bounds?(pos)
  end

  def []=(pos, new_value)
    @grid[pos.first][pos.last] = new_value if in_bounds?(pos)
  end

  def each_row(&prc)
    @grid.each_with_index do |row, index|
      prc.call(row, index)
    end
  end

  def each(&prc)
    @grid.each_with_index do |row, r|
      row.each_with_index do |tile,c|
        prc.call(tile, r, c)
      end
    end
  end
# move validation
  def valid_move?(move, redisplay = false, must_be_jump = false)
    return false if move.nil? || (move.any? {|pos| pos.nil?})
    raise OutOfBoard unless in_bounds?(move)
    source, dest = move.from, move.to
    if source && self[source].moves.include?(dest)
      raise MustChainOnlyJumps unless self[source].jumps.include?(dest)
    else
      raise InvalidMove
    end

    return true
  rescue CheckersExeption => e
    display(e) if redisplay
    return false
  end

  def valid_move_sequence?(moves, redisplay = false) #only for humans
    raise OnlyOnePiecePlease if multiple_pieces?(moves)
    must_be_jump = false
    moves.each do |move|
      return false unless valid_move?(move, false, must_be_jump)
      must_be_jump = true
    end
    true
  rescue CheckersException => e
    display(e) if redisplay
    return false
  end

  def in_bounds?(move_or_pos)
    move_or_pos.all? do |ele|
      if ele.is_a?(Move)
        ele.in_bounds?
      else
        ele.between?(0..7)
      end
    end
  end

  def multiple_pieces?(moves)
    moving_piece = self[moves[0].from]
    moves.any? do |move|
      move.any? do |pos|
        self[pos] && (self[pos] != moving_piece)
      end
    end
  end
# actual move logic
  def make_move(move)
    start_piece = self[move.from]
    start_piece.move_to(move.to)
    self[move.to] = start_piece
    if move.is_jump?
      jumped_piece = self[move.eat_pos]
      if jumped_piece && jumped_piece.is_opponent?(start_piece)
        jumped_piece.move_to(nil)
        @pieces_count[jumped_piece.color] -= 1
      end
      return true
    end
    false
  end

  def over?
    @pieces_count.each do |key, val|
      return true, key if val < 1
    end
  end

# display
  def display(message = nil)
    system('clear')
    welcome_message
    print "#{message}\n"
    each_row do |row, r_i|
      print_blankrow(r_i)
      row.each_with_index do |tile, c_i|
        is_black = ((r_i + c_i) % 2 == 1)
        back_c = is_black ? :green : :magenta
        back_c = :blue if @highlighted.include? [r_i, c_i]
        back_c = :white if @cursor == [r_i, c_i]

        if tile
          tile.display(back_c)
        else
          print "     ".colorize(background: back_c)
        end
      end
      print "\n"
      print_blankrow(r_i)
    end
    history_space
  end

  def welcome_message
    puts "----------------------------------------------------"
    puts "************** Welcome to Checkers *****************"
    puts "----------------------------------------------------"
    puts "Use the arrow keys to select a coordinate. "
    puts "Hit Space to select start to end position"
    puts "Hit Enter to finalize move"
    puts "Enter: 's' to save"
    puts "       'q' to quit"
    # puts "       'h' to toggle history"
    # puts "       'r' to reset game"
    puts "----------------------------------------------------"
  end

  def print_blankrow(r)
    (0..7).each do |i|
      back_c = (i+r) % 2 == 1 ? :green : :magenta
      back_c = :blue if @highlighted.include?([r,i])
      back_c = :red if @cursor == [r, i]
      print "     ".colorize(background: back_c)
    end
    print "\n"
  end

  def history_space

  end

# duplication
  def deep_dup

  end
# board state direct changers
  def starting_board
    init_rows([0, 2], :black)
    init_rows([5, 7], :red)
  end

  def load_game(**options)
    if options[:new_game]
      starting_board
    else
      load_board(options[:red], options[:black])
    end
  end

  def init_row(rows, color)
    (rows.first..rows.last).each do |row|
      start = row % 2
      (start..7).step(2) do |col|
        self[row, col] = Piece.new(color, pos: [row, col], board: self)
      end
    end
  end

end
