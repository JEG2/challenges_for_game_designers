require_relative "item"

module DaBomb
  class ItemCombiner
    COMBINATIONS = {
      [Magnesium,      RustInPipe]   => ThermitePipe,
      [Magnesium,      SignalFlare]  => MagnesiumFlare,
      [RustInPipe,     SignalFlare]  => RustTorch,
      [MagnesiumFlare, RustInPipe]   => ThermiteTorch,
      [Magnesium,      RustTorch]    => ThermiteTorch,
      [SignalFlare,    ThermitePipe] => ThermiteTorch
    }

    def initialize(player, floor)
      @player = player
      @floor  = floor
    end

    attr_reader :player, :floor
    private     :player, :floor

    def can_combine?
      COMBINATIONS.include?(combination)
    end

    def combine
      player.contents = COMBINATIONS.fetch(combination).new
      floor.contents  = nil
      "You combine the items."
    end

    private

    def combination
      [player.contents, floor.contents].map(&:class).sort_by(&:name)
    end
  end
end
