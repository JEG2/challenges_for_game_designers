require_relative "item"
require_relative "tile"

module DaBomb
  class ItemUser
    USES = {
      # good ideas
      [File,       RacingBike]     => :file_item,
      [File,       RustedPipe]     => :file_item,
      [Door,       ThermiteTorch]  => :torch_lock,
      [Bomb,       Paperclip]      => :diffuse_bomb,
      # feedback for bad ideas
      [File,       SignalFlare]    => :swap,
      [File,       Magnesium]      => :file_again,
      [File,       RustInPipe]     => :file_again,
      [Door,       File]           => :file_door,
      [Bomb,       File]           => :file_bomb,
      [Bomb,       SignalFlare]    => :ignite_bomb,
      [RacingBike, SignalFlare]    => :melt_something,
      [RustedPipe, SignalFlare]    => :melt_something,
      [Door,       SignalFlare]    => :melt_lock,
      [Bomb,       ThermiteTorch]  => :ignite_bomb,
      [Door,       Magnesium]      => :use_unfinished_tool,
      [Door,       RustInPipe]     => :use_unfinished_tool,
      [Door,       RustTorch]      => :use_unfinished_tool,
      [Door,       ThermitePipe]   => :use_unfinished_tool,
      [Door,       MagnesiumFlare] => :use_unfinished_tool,
      [Bomb,       Magnesium]      => :use_unfinished_tool,
      [Bomb,       RustInPipe]     => :use_unfinished_tool,
      [Bomb,       RustTorch]      => :use_unfinished_tool,
      [Bomb,       ThermitePipe]   => :use_unfinished_tool,
      [Bomb,       MagnesiumFlare] => :use_unfinished_tool
    }

    def initialize(player, tile)
      @player = player
      @tile   = tile
    end

    attr_reader :player, :tile
    private     :player, :tile

    def can_use?
      USES.include?(item_combination) || USES.include?(tile_combination)
    end

    def use
      send(USES[item_combination] || USES.fetch(tile_combination))
    end

    private

    def item_combination
      [player.contents, tile.walkable? ? tile.contents : nil]
        .map(&:class)
        .sort_by(&:name)
    end

    def tile_combination
      [player.contents, tile].map(&:class).sort_by(&:name)
    end

    def swap
      player.contents, tile.contents = tile.contents, player.contents
      "You swap items."
    end

    def file_item
      message       = "You file the #{tile.contents.name}."
      tile.contents = tile.contents.is_a?(RacingBike) ? Magnesium.new
                                                      : RustInPipe.new

      player.contents.uses += 1
      if player.contents.uses >= 2
        player.contents = nil
      end

      message
    end

    def torch_lock
      return "You're sealed in." if tile.sealed?

      player.contents = nil
      tile.unlock
      "You cut through the lock."
    end

    def diffuse_bomb
      player.contents = nil
      tile.contents   = nil
      "You shorted out the bomb!"
    end

    def file_again
      "You already filed that."
    end

    def file_door
      return "You're sealed in." if tile.sealed?

      "You could cut the lock."
    end

    def file_bomb
      "You need something smaller."
    end

    def ignite_bomb
      "That's probably not safe."
    end

    def melt_something
      "You want to melt that?"
    end

    def melt_lock
      return "You're sealed in." if tile.sealed?

      "You need more heat."
    end

    def use_unfinished_tool
      return "You're sealed in." if tile.is_a?(Door) && tile.sealed?

      "Your tool isn't finished."
    end
  end
end
