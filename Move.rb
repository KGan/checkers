class Move
  attr_accessor :from, :to
  def initialize(from, to)
    @from = from
    @to = to
  end

  def each(&prc)
    prc.call(@from)
    prc.call(@to)
  end

  def all?(&prc)
    valid = true
    each do |pos|
      valid = valid && prc.call(pos)
    end
  end

  def any?(&prc)
    valid = false
    each do |pos|
      valid = valid || prc.call(pos)
    end
  end

  def in_bounds?
    all? {|pos| pos.all? {|x_y| x_y.between?(0, 7)}}
  end


  def eat_pos
    [(from.first + to.first)/2, (from.last + to.last)/2]
  end

  def is_jump?
    Move.sub(@to, @from).any? {|coord| coord.abs > 1}
  end
#class methods
  def self.add(from, step)
    [from.first + step.first, from.last + step.last]
  end

  def self.sub(to,  from)
    [to.first - from.first, to.last - from.last]
  end

  def self.to_move_array(pos_sequence)
    moves = []
    pos_sequence[0...-1].each_with_index do |pos, index|
      moves << Move.new(pos, pos_sequence[index + 1])
    end
    moves
  end

end
