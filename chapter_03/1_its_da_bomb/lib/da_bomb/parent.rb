module DaBomb
  module Parent
    def subclasses
      @subclasses ||= [ ]
    end

    def inherited(subclass)
      subclasses << subclass
    end
  end
end
