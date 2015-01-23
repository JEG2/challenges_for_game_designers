require "stringio"

require_relative "terminal_drawing_context"

module DaBomb
  class StringDrawingContext < TerminalDrawingContext
    def initialize(string = "")
      super(StringIO.new(string))
    end

    def clear(*)
      # ignore
    end

    def to_s
      stream.string
    end
  end
end
