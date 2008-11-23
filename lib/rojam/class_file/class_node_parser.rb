module Rojam
  class ClassNodeParser    
    def parse class_file
      @pool = ConstantPool.new(class_file.cp_info)
      @attribute_parser = AttributeParser.new(@pool)
      ClassNode.new do |node|
        node.version = class_file.major_version
        node.access = class_file.access_flags
      
        node.name = @pool.class_name(class_file.this_class)
        node.super_name = @pool.class_name(class_file.super_class)
        
        class_file.methods.each do |m|
          node.methods << class_method(m)
        end

        class_file.fields.each do |f|
          node.fields << class_field(f)
        end
        
        @attribute_parser.parse_attributes(class_file.attributes, node)
      end      
    end
    
    def class_method(m)
      MethodNode.new do |node|
        node.access = m.access_flags
        node.name = @pool.constant_value(m.name_index)
        node.desc = @pool.constant_value(m.descriptor_index)
        @attribute_parser.parse_attributes(m.attributes, node)
      end
    end

    def class_field(f)
      FieldNode.new do |node|
        node.access = f.access_flags
        node.name = @pool.constant_value(f.name_index)
        node.desc = @pool.constant_value(f.descriptor_index)
        @attribute_parser.parse_attributes(f.attributes, node)
      end
    end
  end
end
