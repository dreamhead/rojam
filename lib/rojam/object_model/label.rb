module Rojam
  class Label
    attr_accessor :line

    def ==(label)
      @line == label.line
    end
  end
end
