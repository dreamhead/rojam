module Rojam
  class AttributeParser
    def initialize constant_pool
      @pool = constant_pool
      @instruction_parser = InstructionParser.new(@pool)
    end
    
    def parse_attributes(attributes, node)
      attributes.each do |attr|
        parse(attr, node)
      end
    end
    
    def parse(attr, node)
      value = @pool.constant_value(attr.attribute_name_index)
      raise "unknown constant value for index #{attr.attribute_name_index}" unless value
      parser_sym = ATTR_PARSERS[value]
      raise "no handler for #{value}" unless parser_sym
      self.send(parser_sym, attr.infoes, node)
    end
    
    ATTR_PARSERS = {
      'SourceFile'  => :parse_source_file,
      'Code'        => :parse_code,
      'LineNumberTable' => :parse_line_number_table
    }
    
    def parse_source_file(infoes, node)
      node.source_file = @pool.constant_value(infoes.to_unsigned)
    end
    
    def parse_line_number_table infoes, node
      attr = LineNumberTableAttribute.new
      attr.read_bytes(infoes)
      attr.table.each do |info|
        node.start_pc = info.start_pc
        node.line_number = info.line_number
      end
    end
    
    def parse_code infoes, node
      code_attr = CodeAttribute.new
      code_attr.read_bytes(infoes)
      
      node.max_stack = code_attr.max_stack
      node.max_locals = code_attr.max_locals
      
      @instruction_parser.parse(node, code_attr.code)
      
      code_attr.attributes.each do |attr|
        parse(attr, node)
      end
    end
  end
end
