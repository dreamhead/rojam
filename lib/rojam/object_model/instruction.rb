module Rojam
  class Instruction
    attr_accessor :opcode
  
    def initialize(opcode)
      @opcode = opcode
    end
    
    def ==(insn)
      @opcode == insn.opcode
    end
  end
end