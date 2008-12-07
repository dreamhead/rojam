module Rojam
  class Label
    attr_accessor :line

    def initialize(line = nil)
      @line = line
    end

    def ==(label)
      @line == label.line
    end
  end
end
