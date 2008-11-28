module Rojam
  class IincInsn < Instruction
    attr_reader :var, :incr

    def initialize opcode, var, incr
      super(opcode)
      @var = var
      @incr = incr
    end

    def ==(insn)
      super(insn) && (@var == insn.var) && (@incr == insn.incr)
    end
  end
end
