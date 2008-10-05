module Rojam
  class MethodInsn < Instruction
    attr_reader :owner, :name, :desc
    def initialize(opcode, owner, name, desc)
      super(opcode)
      @owner = owner
      @name = name
      @desc = desc
    end
  end
end
