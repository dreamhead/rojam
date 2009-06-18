module Rojam
  RBits::Type.array(:code) do
    size :type => :u4
    values :type => :u1
  end

  RBits::Type.array(:exceptions) do
    size :type => :u2
    values :type => :u1
  end

  RBits::Type.array(:exception_index_table) do
    size :type => :u2
    values :type => :u2
  end

  class ExceptionAttribute
    include RBits
    
    exception_index_table :table
  end
  
  class CodeAttribute
    include RBits
    
    u2 :max_stack
    u2 :max_locals
    code :code
    exceptions :exceptions
    attributes :attributes
  end

  RBits::Type.struct(:line_number_info) do
    u2 :start_pc
    u2 :line_number
  end

  RBits::Type.array(:line_number_table) do
    size :type => :u2
    values :type => :line_number_info
  end
  
  class LineNumberTableAttribute
    include RBits
    
    line_number_table :table
  end
  
  class ConstantValueAttribute
    include RBits
    
    u2 :constantvalue_index
  end
  
  class SignatureAttribute
    include RBits
    
    u2 :signature_index;
  end
  
  RBits::Type.struct(:classes) do
    u2 :inner_class_info_index
    u2 :outer_class_info_index
    u2 :inner_name_index
    u2 :inner_class_access_flags
  end
  
  RBits::Type.array(:classes_table) do
    size :type => :u2
    values :type => :classes
  end
  
  class InnerClassesAttribute
    include RBits
    
    classes_table :table
  end
  
  RBits::Type.struct(:enum_const_value) do
    u2 :type_name_index
    u2 :const_name_index
  end
    
  RBits::Type.switch(:element_value) do
    tag :tag, :type => :u1
    value :value, :types =>{
      "B" => :u2,
      "C" => :u2,
      "D" => :u2,
      "F" => :u2,
      "I" => :u2,
      "J" => :u2,
      "S" => :u2,
      "Z" => :u2,
      "s" => :u2,
      "e" => :enum_const_value,
      "c" => :constant_class,
      "@" => :annotation,
    #  "[" => :array_value
    }
  end
  
  # RBits::Type.array(:array_value) do
  #   size :type => :u2
  #   values :type => :element_value
  # end
  
  RBits::Type.struct(:element_value_pair) do
    u2 :element_name_index
    element_value :value
  end
  
  RBits::Type.array(:element_value_pair_table) do
    size :type => :u2
    values :type => :element_value_pair
  end
  
  RBits::Type.struct(:annotation) do
    u2 :type_index
    element_value_pair_table :pair_table
  end
  
  RBits::Type.array(:annotation_table) do
    size :type => :u2
    values :type => :annotation
  end
  
  class RuntimeVisibleAnnotationsAttribute
    include RBits
    
    # TODO finish this structure
    # annotation_table :table
  end
end