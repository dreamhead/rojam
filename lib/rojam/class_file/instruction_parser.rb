module Rojam
  class InstructionParser
    class << self
      def instructions(*bytecode, &block)
        bytecode.each do |single_bytecode|
          define_method instruction_method_name(single_bytecode), &block
        end
      end

      def instruction_method_name(instruction_code)
        "__#{instruction_code}__"
      end
    end

    def initialize constant_pool, labels
      @pool = constant_pool
      @labels = labels
    end
    
    def parse(node, instruction_bytes)
      current = 0
      
      while (current < instruction_bytes.size)
        instruction, consumed_byte_size = parse_instruction(instruction_bytes[current..-1], current)
        node.instructions << instruction
        current += consumed_byte_size
      end
    end

    def parse_instruction(instruction_bytes, current = 0)
      method_name = InstructionParser.instruction_method_name(instruction_bytes[0])
      raise "Instruction #{instruction_bytes[0]}(0x%x) can not be parsed" % instruction_bytes[0] unless self.respond_to?(method_name)
      self.send(method_name, instruction_bytes, current)
    end
    
    private
    instructions(Opcode::INVOKESPECIAL, Opcode::INVOKEVIRTUAL) do |instruction_bytes, current|
      owner_index = instruction_bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      [MethodInsn.new(instruction_bytes[0], owner_name, name, desc), 3]
    end

    instructions(Opcode::ICONST_1,
      Opcode::ILOAD_1, Opcode::ALOAD_0,
      Opcode::ISTORE_1, Opcode::ISTORE_2,
      Opcode::RETURN, Opcode::ARETURN) do |instruction_bytes, current|
      [Instruction.new(instruction_bytes[0]), 1]
    end

    instructions(Opcode::GETSTATIC, Opcode::GETFIELD) do |instruction_bytes, current|
      owner_index = instruction_bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      [FieldInsn.new(instruction_bytes[0], owner_name, name, desc), 3]
    end

    instructions(Opcode::LDC) do |instruction_bytes, current|
      [LdcInsn.new(instruction_bytes[0], @pool.string_value(instruction_bytes[1])), 2]
    end

    instructions(Opcode::IF_ICMPNE) do |instruction_bytes, current|
      offset = instruction_bytes[1..2].to_unsigned
      [JumpInsn.new(instruction_bytes[0], @labels[current + offset]), 3]
    end
  end
end