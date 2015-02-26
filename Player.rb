class Player
  def initialize(color, **options)
    @name = options[:name]
    @color = color
  end

  def get_move(board)
    move_array = []
    begin
      input = read_char
      case input
      when "\e[A" #up
        board.move_cursor(:up)
      when "\e[B" #down
        board.move_cursor(:down)
      when "\e[C" #right
        board.move_cursor(:right)
      when "\e[D" #left
        board.move_cursor(:left)
      when ' '
        highlighted = board.cursor
        move_array << highlighted
        board.highlight(highlighted)
      when '\r'
        highlighted = board.cursor
        if move_array.last != highlighted
          move_array << highlighted
          board.highlight(highlighted)
        end
        raise Ready
      when 'h'
        return ['history']
      when 's'
        return ['save']
      when 'r'
        return ['reset']
      when 'q'
        exit 0
      when "\u0003"
        exit 0
      else
        puts 'invalid action'
      end
      raise NotReady
    rescue InputState => e
      if e.is_a?(Ready)
        board.reset_selection
        return move_array
      end
      retry
    end
  end

  private
    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e"
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!

      return input
    end

end
