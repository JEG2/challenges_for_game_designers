module DaBomb
  class ExplosionScreen
    def initialize(_, final_frame_string)
      @final_frame_grid = final_frame_string.lines.map { |l| l.chomp.chars }
      @bomb_y           = final_frame_grid.find_index { |row| row.include?("*") }
      @bomb_x           = final_frame_grid[bomb_y].find_index("*")
      @explosion_radius = 1
      @keyboard         = Keyboard.new
    end

    attr_reader :final_frame_grid, :bomb_x, :bomb_y, :explosion_radius, :keyboard
    private     :final_frame_grid, :bomb_x, :bomb_y, :explosion_radius, :keyboard

    def update
      case keyboard.get_character
      when "q"
        exit
      when ?\C-c
        fail Interrupt
      end

      @explosion_radius += 3
    end

    def render(drawing_context, frame_delta)
      drawing_context.clear

      screen_filled = true
      final_frame_grid.each_with_index do |row, y|
        row.each_with_index do |character, x|
          if (x - bomb_x) ** 2 + (y - bomb_y) ** 2 <= explosion_radius ** 2
            drawing_context.draw("*")
          else
            screen_filled = false
            drawing_context.draw(character)
          end
        end
        drawing_context.draw("\n")
      end

      exit if screen_filled
    end
  end
end
