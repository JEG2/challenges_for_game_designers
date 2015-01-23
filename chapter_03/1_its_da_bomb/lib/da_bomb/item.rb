require_relative "parent"

module DaBomb
  class Item
    extend Parent

    def self.symbol_map
      @symbol_map ||=
        Hash[subclasses.map { |subclass| [subclass::SYMBOL, subclass] }]
    end

    def name
      self.class.name.sub(/.+::/, "").gsub(/([a-z])([A-Z])/, '\1 \2').downcase
    end

    def carryable?
      true
    end

    def to_s
      self.class::SYMBOL
    end
  end

  class Paperclip < Item
    SYMBOL = "@"
  end

  class RacingBike < Item
    SYMBOL = "%"

    def carryable?
      false
    end
  end

  class RustedPipe < Item
    SYMBOL = "~"

    def carryable?
      false
    end
  end

  class Bomb < Item
    SYMBOL = "*"

    def carryable?
      false
    end
  end

  class SignalFlare < Item
    SYMBOL = "^"
  end

  class File < Item
    SYMBOL = "/"

    def initialize(*)
      super

      @uses = 0
    end

    attr_accessor :uses
  end

  class Magnesium < Item
    SYMBOL = "&"
  end

  class RustInPipe < Item
    SYMBOL = "="
  end

  class ThermitePipe < Item
    SYMBOL = "+"
  end

  class MagnesiumFlare < Item
    SYMBOL = "+"
  end

  class RustTorch < Item
    SYMBOL = "+"
  end

  class ThermiteTorch < Item
    SYMBOL = "+"
  end
end
