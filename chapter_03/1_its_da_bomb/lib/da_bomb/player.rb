require_relative "keyboard"
require_relative "container"
require_relative "item_combiner"
require_relative "item_user"
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

    include Container

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
      to       = level[to_x, to_y]
      combiner = ItemCombiner.new(self, to)
      if can_enter?(to, combiner)
        @x            = to_x
        @y            = to_y
        @moves       += 1
        level.message = handle_item(to, combiner)
      elsif (user = ItemUser.new(self, to)).can_use?
        level.message = user.use
      else
        level.message = feedback(to)
      end
      @facing = new_facing
    end

    def can_enter?(tile, combiner)
      tile.walkable? &&
      ( (!tile.contents? || (tile.contents.carryable? && !contents?)) ||
        combiner.can_combine? )
    end

    def handle_item(floor, combiner)
      combiner.can_combine? ? combiner.combine : pickup_item(floor)
    end

    def pickup_item(floor)
      if floor.contents?
        self.contents  = floor.contents
        floor.contents = nil
      end
    end

    def feedback(tile)
      if tile.walkable? && tile.contents? && !tile.contents.carryable?
        "There's a #{tile.contents.name}."
      elsif tile.is_a?(Door)
        if tile.sealed?
          "You're sealed in."
        else
          "The door is locked."
        end
      else
        "You can't go that way."
      end
    end

    def quit
      exit
    end

    def interrupt
      fail Interrupt
    end
  end

  Floor::SYMBOLS << Player::SYMBOL  # make the Player appear on a Floor tile
end
