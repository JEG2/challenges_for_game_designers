require_relative "parent"
require_relative "item"
require_relative "container"

module DaBomb
  class Tile
    extend Parent

    def self.parse(character)
      subclasses.find( -> {
        fail "Unknown map character:  #{character}"
      } ) { |subclass|
        subclass::SYMBOLS.include?(character)
      }.new(character)
    end

    def initialize(character)
      # ignore character:  subclasses can override and use
    end

    def walkable?
      false
    end

    def to_s
      self.class::SYMBOLS.first
    end
  end

  class Wall < Tile
    SYMBOLS = %w[#]
  end

  class Floor < Tile
    SYMBOLS = %w[.] + Item.symbol_map.keys

    include Container

    def initialize(character)
      super

      item          = Item.symbol_map[character]
      self.contents = item.new if item
    end

    def walkable?
      true
    end

    def to_s
      if contents?
        contents.to_s
      else
        super
      end
    end
  end

  class Door < Tile
    SYMBOLS = %w[| $]

    include Container  # must support Floor interface, once opened

    def initialize(character)
      super

      @locked = true
      @sealed = character == "$"
    end

    def locked?
      @locked
    end

    def sealed?
      @sealed
    end

    def walkable?
      !locked? && !sealed?
    end

    def unlock
      @locked = false
    end

    def to_s
      if walkable?
        Floor::SYMBOLS.first
      else
        super
      end
    end
  end
end
