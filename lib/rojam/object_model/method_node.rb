module Rojam
  class MethodNode
    attr_accessor :access, :name, :desc, :max_stack, :max_locals, :instructions,
      :start_pc, :line_number
    
    def initialize
      @instructions = []
      yield self if block_given?
    end
  end
end
