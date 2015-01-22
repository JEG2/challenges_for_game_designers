module DaBomb
  class TerminalDrawingContext
    ERASE_DISPLAY_ANSI_ESCAPE_SEQUENCE   = "\e[2J"
    CURSOR_POSITION_ANSI_ESCAPE_SEQUENCE = "\e[y;xH"

    def initialize(stream = $stdout)
      @stream = stream
    end

    attr_reader :stream
    private     :stream

    def clear
      draw(ERASE_DISPLAY_ANSI_ESCAPE_SEQUENCE)
      move_to(1, 1)
    end

    def draw(content)
      stream.write(content.to_s.gsub("\n", "\r\n"))
    end

    def move_to(x, y)
      draw(
        CURSOR_POSITION_ANSI_ESCAPE_SEQUENCE.sub("x", x.to_s).sub("y", y.to_s)
      )
    end
  end
end
