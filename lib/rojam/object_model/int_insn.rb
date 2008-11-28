module Rojam
  class IntInsn < Instruction
    attr_accessor :operand
    
    def initialize(opcode, operand)
      super(opcode)
      @operand = operand
    end

    def ==(insn)
      super(insn) && (@operand == insn.operand)
    end
  end
end
