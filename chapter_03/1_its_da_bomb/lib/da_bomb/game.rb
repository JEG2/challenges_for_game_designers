require_relative "terminal_drawing_context"

module DaBomb
  class Game
    UPDATES_PER_SECOND = 4

    def initialize(drawing_context = TerminalDrawingContext.new, &screen_builder)
      @drawing_context    = drawing_context
      @screen             = screen_builder.call(self)
      @seconds_per_update = 1.0 / UPDATES_PER_SECOND
      @last_redraw        = nil
    end

    attr_accessor :screen

    attr_reader :drawing_context, :seconds_per_update, :last_redraw
    private     :drawing_context, :seconds_per_update, :last_redraw

    def tick
      elapsed = last_redraw.nil? ? seconds_per_update : Time.now - last_redraw

      while elapsed >= seconds_per_update
        screen.update
        elapsed -= seconds_per_update
      end

      screen.render(drawing_context, elapsed / seconds_per_update)

      @last_redraw = Time.now
    end

    def run
      loop do
        tick

        remaining_seconds = seconds_per_update - (Time.now - last_redraw)
        sleep remaining_seconds if remaining_seconds > 0
      end
    end
  end
end
