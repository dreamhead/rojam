module Rojam
  class InstructionParser
    class << self
      def instruction(instruction_code, &block)
        define_method instruction_method_name(instruction_code), &block
      end

      def instruction_method_name(instruction_code)
        "__#{instruction_code}__"
      end
    end

    def initialize constant_pool
      @pool = constant_pool
    end
    
    def parse(node, instruction_bytes)
      current = 0
      
      while (current < instruction_bytes.size)
        instruction, consumed_byte_size = parse_instruction(instruction_bytes[current..-1])
        node.instructions << instruction
        current += consumed_byte_size
      end
    end

    def parse_instruction(instruction_bytes)
      method_name = InstructionParser.instruction_method_name(instruction_bytes[0])
      if (self.respond_to?(method_name))
        self.send(method_name, instruction_bytes)
      else
        [Instruction.new(instruction_bytes[0]), 1]
      end
    end
    
    private
    instruction(Opcode::INVOKESPECIAL) do |instruction_bytes|
      owner_index = instruction_bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      [MethodInsn.new(instruction_bytes[0], owner_name, name, desc), 3]
    end
  end
end