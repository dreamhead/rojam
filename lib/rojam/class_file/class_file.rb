module Rojam
  class Interfaces < RBits::Array
    size :type => :u2
    values :type => :u2
  
    field_type :interfaces
  end

  class Info < RBits::Array
    size :type => :u4
    values :type => :u1
  
    field_type :info
  end

  class AttributeInfo < RBits::Struct
    u2 :attribute_name_index
    info :infoes
  
    field_type :attribute_info
  end

  class Attributes < RBits::Array
    size :type => :u2
    values :type => :attribute_info
  
    field_type :attributes
  end

  class FieldInfo < RBits::Struct
    u2 :access_flags
    u2 :name_index
    u2 :descriptor_index
    attributes :attributes
  
    field_type :field_info
  end

  class Fileds < RBits::Array
    size :type => :u2
    values :type => :field_info
  
    field_type :fields
  end

  class MethodInfo < RBits::Struct
    u2 :access_flags
    u2 :name_index
    u2 :descriptor_index
    attributes :attributes
  
    field_type :method_info
  end

  class Methods < RBits::Array
    size :type => :u2
    values :type => :method_info
  
    field_type :methods
  end

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
    
    def to_node
      ClassNode.new do |node|
        node.version = self.major_version
        node.access = self.access_flags
      
        node.name = this_class_name
        node.super_name = super_class_name
        node.interfaces = []
        
        node.fields = []
        node.methods = [1]
      end
    end
    
    private
    def this_class_name
      class_name(self.this_class)
    end
    
    def super_class_name
      class_name(self.super_class)
    end
    
    def class_name index
      name_index = constant_value(index).name_index
      constant_value(name_index)
    end
    
    def constant_value(index)
      cp_info[index - 1].info
    end
  end
end