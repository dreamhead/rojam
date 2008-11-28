module Rojam
  class JumpInsn < Instruction
    attr_reader :label
    def initialize opcode, label
      super(opcode)
      @label = label
    end

    def ==(insn)
      super(insn) && @label == insn.label
    end
  end
end
