module Rojam
  RBits::Type.string(:constant_utf8) do
    size :type => :u2
  end
  
  RBits::Type.struct(:constant_integer) do
    u4 :bytes
  end
  
  RBits::Type.struct(:constant_float) do
    u4 :bytes
  end
  
  RBits::Type.struct(:constant_long) do
    u4 :high_bytes
    u4 :low_bytes
  end
  
  RBits::Type.struct(:constant_double) do
    u4 :high_bytes
    u4 :low_bytes
  end
  
  RBits::Type.struct(:constant_class) do
    u2 :name_index
  end
  
  RBits::Type.struct(:constant_string) do
    u2 :string_index
  end
  
  RBits::Type.struct(:constant_fieldref) do
    u2 :class_index
    u2 :name_and_type_index
  end
  
  RBits::Type.struct(:constant_methodref) do
    u2 :class_index
    u2 :name_and_type_index
  end
  
  RBits::Type.struct(:constant_name_and_type) do
    u2 :name_index
    u2 :descriptor_index
  end
  
  RBits::Type.struct(:constant_interfacemethodref) do
    u2 :class_index
    u2 :name_and_type_index
  end
  
  RBits::Type.switch(:cp_info) do
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
  end
  
  RBits::Type.array(:cp_info_array) do
    size :type => :u2, 
      :read_proc => lambda {|size| size - 1 }, 
      :write_proc => lambda {|size| size + 1 }
    values :type => :cp_info
  end
end