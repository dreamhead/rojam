module Rojam
  class InstructionParser
    class << self
      def instructions(consumed_byte_size, *bytecode, &block)
        bytecode.each do |single_bytecode|
          define_method instruction_method_name(single_bytecode), &block
          consumed_byte_size_table[single_bytecode] = consumed_byte_size
        end
      end

      def instruction_method_name(instruction_code)
        "__#{instruction_code}__"
      end

      def consumed_byte_size(bytecode)
        consumed_byte_size_table[bytecode]
      end

      private
      def consumed_byte_size_table
        @consumed_byte_size ||= {}
      end
    end

    def initialize constant_pool, labels
      @pool = constant_pool
      @labels = labels
    end
    
    def parse(node, instruction_bytes)
      current = 0
      
      while (current < instruction_bytes.size)
        instruction = parse_instruction(instruction_bytes[current..-1], current)
        node.instructions << instruction
        current += InstructionParser.consumed_byte_size(instruction_bytes[current])
      end
    end

    def parse_instruction(bytes, current = 0)
      method_name = InstructionParser.instruction_method_name(bytes[0])
      raise "Instruction #{bytes[0]}(0x%x) can not be parsed" % bytes[0] unless self.respond_to?(method_name)
      self.send(method_name, bytes, current)
    end
    
    private
    instructions(3, Opcode::INVOKESPECIAL, Opcode::INVOKEVIRTUAL) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      MethodInsn.new(bytes[0], owner_name, name, desc)
    end

    instructions(1, Opcode::ICONST_0, Opcode::ICONST_1, Opcode::ICONST_2, Opcode::ICONST_3, Opcode::ICONST_4,
      Opcode::ILOAD_1, Opcode::ALOAD_0,
      Opcode::IADD, Opcode::ISUB, Opcode::IMUL, Opcode::IDIV,
      Opcode::RETURN, Opcode::ARETURN) do |bytes, current|
      Instruction.new(bytes[0])
    end

    instructions(3, Opcode::GETSTATIC, Opcode::GETFIELD) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      FieldInsn.new(bytes[0], owner_name, name, desc)
    end

    instructions(2, Opcode::LDC) do |bytes, current|
      LdcInsn.new(bytes[0], @pool.string_value(bytes[1]))
    end

    instructions(3, Opcode::IF_ICMPNE, Opcode::IF_ICMPGE, Opcode::GOTO) do |bytes, current|
      offset = bytes[1..2].to_unsigned
      JumpInsn.new(bytes[0], @labels[current + offset])
    end

    instructions(2, Opcode::BIPUSH) do |bytes, current|
      IntInsn.new(bytes[0], bytes[1])
    end

    instructions(3, Opcode::IINC) do |bytes, current|
      IincInsn.new(bytes[0], bytes[1], bytes[2])
    end

    instructions(2, Opcode::ISTORE) do |bytes, current|
      VarInsn.new(bytes[0], bytes[1])
    end

    instructions(1, Opcode::ISTORE_0, Opcode::ISTORE_1, Opcode::ISTORE_2, Opcode::ISTORE_3) do |bytes, current|
      VarInsn.new(Opcode::ISTORE, (bytes[0] - Opcode::ISTORE_0))
    end

    instructions(2, Opcode::ILOAD) do |bytes, current|
      VarInsn.new(bytes[0], bytes[1])
    end

    instructions(1, Opcode::ILOAD_0, Opcode::ILOAD_1, Opcode::ILOAD_2, Opcode::ILOAD_3) do |bytes, current|
      VarInsn.new(Opcode::ILOAD, (bytes[0] - Opcode::ILOAD_0))
    end
  end
end