class Piece
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
    white: {
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
    @isKing = false
    @pos = options[:position]
    @board = options[:board]
  end

  def moves
  end

  def move()
    # makes a move
    # returns whether it is chainable
  end

  def deep_dup
  end

end
