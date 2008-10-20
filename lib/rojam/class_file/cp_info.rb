module Rojam
  class CONSTANT_Utf8 < RBits::String
    size :type => :u2
  
    field_type :constant_utf8
  end
  
  class CONSTANT_Integer < RBits::Struct
    u4 :bytes
    
    field_type :constant_integer
  end
  
  class CONSTANT_Float < RBits::Struct
    u4 :bytes
    
    field_type :constant_float
  end
  
  class CONSTANT_Long < RBits::Struct
    u4 :high_bytes
    u4 :low_bytes
    
    field_type :constant_long
  end
  
  class CONSTANT_Double < RBits::Struct
    u4 :high_bytes
    u4 :low_bytes
    
    field_type :constant_double
  end

  class CONSTANT_Class < RBits::Struct
    u2 :name_index
  
    field_type :constant_class
  end
  
  class CONSTANT_String < RBits::Struct
    u2 :string_index
  
    field_type :constant_string
  end

  class CONSTANT_Fieldref < RBits::Struct
    u2 :class_index
    u2 :name_and_type_index
  
    field_type :constant_fieldref
  end

  class CONSTANT_Methodref < RBits::Struct
    u2 :class_index
    u2 :name_and_type_index
  
    field_type :constant_methodref
  end

  class CONSTANT_NameAndType < RBits::Struct
    u2 :name_index
    u2 :descriptor_index
  
    field_type :constant_name_and_type
  end
  
  class CONSTANT_InterfaceMethodref < RBits::Struct
    u2 :class_index
    u2 :name_and_type_index
    
    field_type :constant_interfacemethodref
  end

  class CpInfo < RBits::Switch
    tag :tag, :type => :u1
    value :info, :types => {
      1   => :constant_utf8,
      3   => :constant_integer,
      4   => :constant_float,
      5   => :constant_long,
      6   => :constant_double,
      7   => :constant_class,
      8   => :constant_string,
      9   => :constant_fieldref,
      10  => :constant_methodref,
      11  => :constant_interfacemethodref,
      12  => :constant_name_and_type
    }
  
    field_type :cp_info
  end

  class CpInfoArray < RBits::Array
    size :type => :u2, 
      :read_proc => lambda {|size| size - 1 }, 
      :write_proc => lambda {|size| size + 1 }
    values :type => :cp_info
  
    field_type :cp_info_array
  end
end