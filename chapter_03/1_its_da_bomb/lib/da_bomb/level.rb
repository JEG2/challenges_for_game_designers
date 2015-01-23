require_relative "player"
require_relative "tile"

module DaBomb
  class Level
    TIMER = 300

    def initialize(game, number = 1)
      @game    = game
      @number  = 1
      @grid    = nil
      @player  = nil
      @message = nil

      parse_level
    end

    attr_accessor :message

    attr_reader :game, :number, :grid, :player
    private     :game, :number, :grid, :player

    def [](x, y)
      grid[y][x]
    end

    def update
      player.update
    end

    def render(drawing_context, frame_delta)
      drawing_context.clear

      solved = true
      grid.each_with_index do |row, y|
        row.each_with_index do |tile, x|
          if player.x == x && player.y == y
            drawing_context.draw(player)
          else
            solved = false if tile.walkable? && tile.contents.is_a?(Bomb)
            drawing_context.draw(tile)
          end
        end
        drawing_context.draw("\n")
      end
      drawing_context.draw(build_status_line)

      exit if solved
    end

    private

    def parse_level
      open(::File.join(__dir__, *%W[.. .. data level_#{number}.txt])) do |file|
        @grid = [ ]
        file.each_with_index do |line, y|
          grid << [ ]
          line.strip.chars.each_with_index do |character, x|
            grid.last << Tile.parse(character)
            @player = Player.new(self, x, y) if character == Player::SYMBOL
          end
        end
      end
    end

    def build_status_line
      "%-26s %26s %26s\n" % [
        "Timer: #{TIMER - player.moves}",
        player.contents? ? "Holding: #{player.contents.name}".center(26) : "",
        message
      ]
    end
  end
end
