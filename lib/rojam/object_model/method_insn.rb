module Rojam
  class MethodInsn < Instruction
    attr_reader :owner, :name, :desc
    
    def initialize(opcode, owner, name, desc)
      super(opcode)
      @owner = owner
      @name = name
      @desc = desc
    end

    def ==(insn)
      super(insn) && @owner == insn.owner && @name == insn.name && @desc == insn.desc
    end
  end
end
