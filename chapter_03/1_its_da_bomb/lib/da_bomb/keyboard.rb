require "io/wait"
require "io/console"

module DaBomb
  class Keyboard
    ARROW_KEY_PREFIX            = "\eO"
    CONTROL_SEQUENCE_INTRODUCER = "\e["

    def self.default_input_stream
      @default_input_stream ||= $stdin
    end

    def self.default_input_stream=(stream)
      @default_input_stream = stream
    end

    def self.activate_raw_mode(stream = default_input_stream, &game_code)
      stream.raw do |raw_stream|
        old_stream = default_input_stream
        begin
          self.default_input_stream = raw_stream
          game_code.call
        ensure
          self.default_input_stream = old_stream
        end
      end
    end

    def initialize(stream = self.class.default_input_stream)
      @stream = stream
    end

    attr_reader :stream
    private     :stream

    def get_character
      if stream.ready?
        character = stream.sysread(1)
        while ( ARROW_KEY_PREFIX.start_with?(character)              ||
                CONTROL_SEQUENCE_INTRODUCER.start_with?(character) ) &&
              stream.ready?
          character << stream.sysread(1)
        end
        character
      end
    end
  end
end
