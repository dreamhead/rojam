module Rojam
  class Code < RBits::Array
    size :type => :u4
    values :type => :u1
  
    field_type :code
  end
  
  class ExceptionTable < RBits::Array
    size :type => :u2
    values :type => :u1
    
    field_type :exceptions
  end
  
  class CodeAttribute < RBits::Base
    u2 :max_stack
    u2 :max_locals
    code :code
    exceptions :exceptions
    attributes :attributes
  end
  
  class LineNumberInfo < RBits::Struct
    u2 :start_pc
    u2 :line_number
    
    field_type :line_number_info
  end
  
  class LineNumberTable < RBits::Array
    size :type => :u2
    values :type => :line_number_info
    
    field_type :line_number_table
  end
  
  class LineNumberTableAttribute < RBits::Base
    line_number_table :table
  end
end