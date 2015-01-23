module DaBomb
  module Container
    attr_writer :contents

    def contents
      @contents ||= nil
    end

    def contents?
      !contents.nil?
    end
  end
end
