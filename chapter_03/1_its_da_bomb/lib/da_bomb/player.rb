require_relative "keyboard"
require_relative "tile"

module DaBomb
  class Player
    SYMBOL   = "M"
    COMMANDS = {
      "\eOA" => :move_north,
      "\e[A" => :move_north,
      "\eOB" => :move_south,
      "\e[B" => :move_south,
      "\eOC" => :move_east,
      "\e[C" => :move_east,
      "\eOD" => :move_west,
      "\e[D" => :move_west,
      ?q     => :quit,
      ?\C-c  => :interrupt
    }

    def initialize(level, x, y)
      @level    = level
      @x        = x
      @y        = y
      @facing   = :west
      @moves    = 0
      @keyboard = Keyboard.new
    end

    attr_reader :x, :y, :facing, :moves

    attr_reader :level, :keyboard
    private     :level, :keyboard

    def update
      command = COMMANDS[keyboard.get_character]
      send(command) if command
    end

    def to_s
      SYMBOL
    end

    private

    def move_north; move(x,     y - 1, :north) end
    def move_south; move(x,     y + 1, :south) end
    def move_east;  move(x + 1, y,     :east)  end
    def move_west;  move(x - 1, y,     :west)  end

    def move(to_x, to_y, new_facing)
      if level[to_x, to_y].is_a?(Floor)
        @x      = to_x
        @y      = to_y
        @moves += 1
        level.message = nil
      else
        level.message = "You can't go that way."
      end
      @facing = new_facing
    end

    def quit
      exit
    end

    def interrupt
      fail Interrupt
    end
  end
end
