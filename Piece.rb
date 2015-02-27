class Piece
  attr_accessor :color, :pos
  KING_ROW = {:red => 0, :black => 7}
  VALID_DIRECTIONS = {
    red: {
      jump: [
        [-2,  2],
        [-2, -2]
      ],
      step: [
        [-1,  1],
        [-1, -1],
      ]
    },
    black: {
      jump: [
        [2,  2],
        [2, -2]
      ],
      step: [
        [1,  1],
        [1, -1],
      ]
    },
    king: {
      jump: [
        [2,  2],
        [2, -2],
        [-2,  2],
        [-2, -2]
      ],
      step: [
        [1,  1],
        [1, -1],
        [-1,  1],
        [-1, -1],
      ]
    }
  }

  def initialize(**options)
    @color = options[:color]
    @isKing = false || options[:isKing]
    @pos = options[:position]
    @board = options[:board]
  end

  def king
    @isKing
  end

  def kingify
    @isKing = true if @pos.first == KING_ROW[@color]
  end

  def self.would_kingify?(color, pos)
    return false if color.nil? || pos.nil?
    pos.first == KING_ROW[color]
  end

# moves
  def moves
    c_index = king ? :king : @color
    [].tap do |move_array|
      steps = VALID_DIRECTIONS[c_index][:step]
      jumps = VALID_DIRECTIONS[c_index][:jump]
      steps.each_with_index do |step, i|
        if neighbor?(step)
          move_array << Move.add(@pos, jumps[i]) unless neighbor?(jumps[i])
        else
          move_array << Move.add(@pos, step)
        end
      end
    end
  end

  def self.jumps(color, board, pos, king)
    c_i = king ? :king : color
    [].tap do |jump_array|
      jumps = VALID_DIRECTIONS[c_i][:jump]
      jumps.each do |jump|
        new_pos = Move.add(pos, jump)
        jump_array << new_pos if !board[new_pos]
      end
    end
  end

#display
  def display(back_c)
    print "  #{utf_symbol}  ".colorize(background: back_c, color: @color)
  end

  def utf_symbol
    if king
      @color == :red ? "\u2622" : "\u2623"
    else
      @color == :red ? "\u267C" : "\u267D"
    end
  end

  def is_opponent?(other_piece)
    @color != other_piece.color
  end

  def same_color?(color)
    @color == color
  end

  def move_to(pos)
    @pos = pos
  end

  def neighbor?(step)
    !!@board[Move.add(@pos, step)]
  end

  def deep_dup
  end

end
