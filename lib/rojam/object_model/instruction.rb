module Rojam
  class Instruction
    attr_accessor :opcode
  
    def initialize(opcode)
      @opcode = opcode
    end
    
    def ==(insn)
      (self.class == insn.class) && (@opcode == insn.opcode)
    end
  end
end