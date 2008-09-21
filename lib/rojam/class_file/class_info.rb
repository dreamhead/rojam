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
end