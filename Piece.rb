class Piece
  attr_reader :color, :pos
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
    }
  }
  def initialize(**options)
    @color = options[:color]
    @isKing = false || options[:isKing]
    @pos = options[:position]
    @board = options[:board]
  end
# moves
  def moves
    [].tap do |move_array|
      step1 = VALID_DIRECTIONS[@color][:step].first
      step2 = VALID_DIRECTIONS[@color][:step].last
      jump1 = VALID_DIRECTIONS[@color][:jump].first
      jump2 = VALID_DIRECTIONS[@color][:jump].last
      if neighbor?(step1)
        move_array << jump1 unless neighbor?(jump1)
      else
        move_array << step1
      end

      if neighbor?(step2)
        move_array << jump2 unless neighbor?(jump2)
      else
        move_array << step2
      end
    end
  end

  def jumps
    [].tap do |jump_array|
      jump1 = VALID_DIRECTIONS[@color][:jump].first
      jump2 = VALID_DIRECTIONS[@color][:jump].last
      jump_array = [jump1, jump2].select do |jump|
        !neighbor?(jump)
      end
    end
  end
#display
  def display
    print "  #{utf_symbol}  ".colorize(background: back_c, color: @color)
  end

  def utf_symbol
    @color == :red ? "\u267C" : "\u267D"
  end

  def is_opponent?(other_piece)
    @color != other_piece.color
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
