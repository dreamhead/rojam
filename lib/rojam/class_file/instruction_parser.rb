module Rojam
  class InstructionParser
    include Opcode

    class << self
      {
        :no_arg       => 1,
        :var          => 2,
        :implicit_var => 1,
        :ldc          => 2,
        :label        => 3,
        :method       => 3,
        :field        => 3,
        :int          => 2,
        :iinc         => 3,
        :type         => 3
      }.each do |type, size|
        class_eval %Q{
          def #{type}_instructions(*opcode, &block)
            instructions(#{size}, *opcode, &block)
          end
        }
      end

      def instructions(consumed_byte_size, *opcode, &block)
        opcode.each do |single_bytecode|
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
    
    def parse(node, bytes)
      current = 0
      
      while (current < bytes.size)
        instruction = parse_instruction(bytes[current..-1], current)
        node.instructions << instruction
        current += InstructionParser.consumed_byte_size(bytes[current])
      end
    end

    def parse_instruction(bytes, current = 0)
      method_name = InstructionParser.instruction_method_name(bytes[0])
      raise "Instruction #{bytes[0]}(0x%x) can not be parsed" % bytes[0] unless self.respond_to?(method_name)
      self.send(method_name, bytes, current)
    end
    
    private
    method_instructions(INVOKESPECIAL, INVOKEVIRTUAL) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      MethodInsn.new(bytes[0], owner_name, name, desc)
    end

    no_arg_instructions(NOP,
      ACONST_NULL,
      ICONST_M1, ICONST_0, ICONST_1, ICONST_2, ICONST_3, ICONST_4, ICONST_5,
      ILOAD_1, ALOAD_0,
      IADD, ISUB, IMUL, IDIV,
      DUP,
      RETURN, ARETURN) do |bytes, current|
      Instruction.new(bytes[0])
    end

    field_instructions(GETSTATIC, GETFIELD) do |bytes, current|
      owner_index = bytes[1..2].to_unsigned
      owner_name = @pool.method_owner_name(owner_index)
      name, desc = @pool.name_and_desc(owner_index)
      FieldInsn.new(bytes[0], owner_name, name, desc)
    end

    ldc_instructions(LDC) do |bytes, current|
      LdcInsn.new(bytes[0], @pool.string_value(bytes[1]))
    end

    label_instructions(IF_ICMPNE, IF_ICMPGE, GOTO) do |bytes, current|
      offset = bytes[1..2].to_unsigned
      JumpInsn.new(bytes[0], @labels[current + offset])
    end

    int_instructions(BIPUSH) do |bytes, current|
      IntInsn.new(bytes[0], bytes[1])
    end

    iinc_instructions(IINC) do |bytes, current|
      IincInsn.new(bytes[0], bytes[1], bytes[2])
    end

    var_instructions(ISTORE, ILOAD, ASTORE) do |bytes, current|
      VarInsn.new(bytes[0], bytes[1])
    end

    implicit_var_instructions(ISTORE_0, ISTORE_1, ISTORE_2, ISTORE_3) do |bytes, current|
      VarInsn.new(ISTORE, (bytes[0] - ISTORE_0))
    end

    implicit_var_instructions(ASTORE_0, ASTORE_1, ASTORE_2, ASTORE_3) do |bytes, current|
      VarInsn.new(ASTORE, (bytes[0] - ASTORE_0))
    end

    implicit_var_instructions(ILOAD_0, ILOAD_1, ILOAD_2, ILOAD_3) do |bytes, current|
      VarInsn.new(ILOAD, (bytes[0] - ILOAD_0))
    end

    type_instructions(NEW) do |bytes, current|
      type = @pool.type_name(bytes[1..2].to_unsigned)
      TypeInsn.new(bytes[0], type)
    end
  end
end