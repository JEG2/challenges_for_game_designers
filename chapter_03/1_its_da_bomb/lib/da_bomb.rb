require_relative "da_bomb/game"
require_relative "da_bomb/level"
require_relative "da_bomb/keyboard"

module DaBomb
  module_function

  def play
    Keyboard.activate_raw_mode do
      game = Game.new { |g| Level.new(g) }
      game.run
    end
  end
end
