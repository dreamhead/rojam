module Rojam
  module AttributeParser
    include InstructionParser
    
    def parse_attributes(attributes, node)
      attributes.each do |attr|
        parse_attribute(attr, node)
      end
    end
    
    def parse_attribute(attr, node)
      value = constant_value(attr.attribute_name_index)
      raise "unknown constant value for index #{attr.attribute_name_index}" unless value
      parser_sym = ATTR_PARSERS[value]
      raise "no handler for #{value}" unless parser_sym
      self.send(parser_sym, node, attr.infoes)
    end
    
    private
    ATTR_PARSERS = {
      'SourceFile'  => :parse_source_file,
      'Code'        => :parse_code,
      'LineNumberTable' => :parse_line_number_table
    }
    
    def source_file(infoes)
      constant_value(infoes.to_unsigned)
    end
    
    def parse_source_file(node, infoes)
      node.source_file = source_file(infoes)
    end
    
    MAX_STACK_START   = 0
    MAX_STACK_END     = 1
    MAX_LOCALS_START  = 2
    MAX_LOCALS_END    = 3
    CODE_SIZE_START   = 4
    CODE_SIZE_END     = 7
    
    def parse_code node, infoes
      code_attr = CodeAttribute.new
      code_attr.read_bytes(infoes)
      
      node.max_stack = code_attr.max_stack
      node.max_locals = code_attr.max_locals
      
      parse_instructions(node, code_attr.code)
      
      code_attr.attributes.each do |attr|
        parse_attribute(attr, node)
      end
    end
    
    def parse_line_number_table node, infoes
      attr = LineNumberTableAttribute.new
      attr.read_bytes(infoes)
      attr.table.each do |info|
        node.start_pc = info.start_pc
        node.line_number = info.line_number
      end
    end
  end
end