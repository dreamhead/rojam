module Rojam
  class TypeInsn < Instruction
    attr_reader :type
    
    def initialize opcode, type
      super(opcode)
      @type = type
    end
  end
end
