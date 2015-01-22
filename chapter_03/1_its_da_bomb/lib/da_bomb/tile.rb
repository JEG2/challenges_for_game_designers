module DaBomb
  class Tile
    def self.subclasses
      @subclasses ||= [ ]
    end

    def self.inherited(subclass)
      subclasses << subclass
    end

    def self.parse(character)
      subclasses.find( -> {
        fail "Unknown map character:  #{character}"
      } ) { |subclass|
        subclass::SYMBOLS.include?(character)
      }.new
    end

    def to_s
      self.class::SYMBOLS.first
    end
  end

  class Wall < Tile
    SYMBOLS = %w[#]
  end

  class Floor < Tile
    SYMBOLS = %w[. M]
  end

  class Door < Tile
    SYMBOLS = %w[|]
  end
end
