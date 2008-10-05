module Rojam
  class ClassFile < RBits::Base
    u4 :magic, :const => 0xCAFEBABE
    u2 :minor_version
    u2 :major_version
    cp_info_array :cp_info
    u2 :access_flags
    u2 :this_class
    u2 :super_class
    interfaces :interfaces
    fields :fields
    methods :methods
    attributes :attributes
    
    include Rojam::AttributeParser
    include Rojam::CpParser
    
    def to_node
      ClassNode.new do |node|
        node.version = self.major_version
        node.access = self.access_flags
      
        node.name = this_class_name
        node.super_name = super_class_name
        
        self.methods.each do |m|
          node.methods << class_method(m)
        end
        
        parse_attributes(self.attributes, node)
      end
    end
    
    private
    def this_class_name
      class_name(self.this_class)
    end
    
    def super_class_name
      class_name(self.super_class)
    end
    
    def constant_value(index)
      cp_info[index - 1].info
    end
    
    def class_method(m)
      MethodNode.new do |node|
        node.access = m.access_flags
        node.name = constant_value(m.name_index)
        node.desc = constant_value(m.descriptor_index)
        parse_attributes(m.attributes, node)
      end
    end
  end
end