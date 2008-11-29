module Rojam
  class VarInsn < Instruction
    attr_reader :var
    
    def initialize opcode, var
      super(opcode)
      @var = var
    end

    def ==(insn)
      super(insn) && @var == insn.var
    end
  end
end
