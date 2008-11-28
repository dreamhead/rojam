module Rojam
  class JumpInsn < Instruction
    attr_reader :offset # TODO use label instread
    def initialize opcode, offset
      super(opcode)
      @offset = offset
    end

    def ==(insn)
      super(insn) && @offset == insn.offset
    end
  end
end
