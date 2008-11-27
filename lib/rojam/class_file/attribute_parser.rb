module Rojam
  class AttributeParser
    class << self
      def attribute(name, &block)
        define_method(attribute_method_name(name), &block)
      end
      
      def attribute_method_name(name)
        "__#{name}__"
      end
    end
    
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
      parse_attribute(value, attr.infoes, node)
    end
    
    def parse_attribute(attr, infoes, node)
      method_name = AttributeParser.attribute_method_name(attr)
      raise "attribute #{attr} can not be parsed" unless self.respond_to?(method_name)
      self.send(method_name, infoes, node)
    end
    
    attribute('SourceFile') do |infoes, node|
      node.source_file = @pool.constant_value(infoes.to_unsigned)
    end
    
    attribute('Code') do |infoes, node|
      code_attr = attribute_from_bytes(infoes, CodeAttribute)
      
      node.max_stack = code_attr.max_stack
      node.max_locals = code_attr.max_locals
      
      @instruction_parser.parse(node, code_attr.code)
      
      code_attr.attributes.each do |attr|
        parse(attr, node)
      end
    end
    
    attribute('LineNumberTable') do |infoes, node|
      attr = attribute_from_bytes(infoes, LineNumberTableAttribute)
      attr.table.each do |info|
        node.start_pc = info.start_pc
        node.line_number = info.line_number
      end
    end

    attribute('ConstantValue') do |infoes, node|
      attr = attribute_from_bytes(infoes, ConstantValueAttribute)
      node.value = @pool.value(attr.constantvalue_index)
    end

    def attribute_from_bytes(bytes, klass)
      klass.new { |attr| attr.read_bytes(bytes) }
    end
  end
end