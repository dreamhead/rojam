module Rojam
  class LdcInsn < Instruction
    attr_accessor :constant
    
    def initialize(code, constant)
      super(code)
      @constant = constant
    end
  end
end
