module Rojam
  module InstructionParser
    include CpParser
    
    def parse_instructions(node, instruction_bytes)
      current = 0
      
      while (current < instruction_bytes.size)
        if (instruction_bytes[current] == Opcode::INVOKESPECIAL)
          node.instructions << parse_invokespecial(instruction_bytes[current..-1])
          current += 3
        else
          node.instructions << Instruction.new(instruction_bytes[current])
          current += 1
        end
      end
    end
    
    private
    def parse_invokespecial instruction_bytes
      owner_index = instruction_bytes[1..2].to_unsigned
      owner_name = method_owner_name(owner_index)
      name, desc = name_and_desc(owner_index)
      MethodInsn.new(instruction_bytes[0], owner_name, name, desc)
    end
  end
end