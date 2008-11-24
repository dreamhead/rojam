module Rojam
  module ConstantPoolHelper
    def class_name index
      cp_value = constant_value(index)
      constant_value(cp_value.name_index) if (cp_value)
    end
      
    def method_owner_name index
      cp_value = constant_value(index)
      class_name(cp_value.class_index) if (cp_value)
    end
    
    def name_and_desc index
      cp_value = constant_value(index)
      if (cp_value)
        name_and_type_index = cp_value.name_and_type_index
        value = constant_value(name_and_type_index)
        if (value)
          [constant_value(value.name_index), constant_value(value.descriptor_index)]
        end
      end
    end

    def string index
      cp_value = constant_value(index)
      constant_value(cp_value.string_index) if (cp_value)
    end
  end
  
  class ConstantPool
    include ConstantPoolHelper
    
    def initialize cp_info_list
      @cp_info_list = cp_info_list
    end
    
    def constant_value index
      cp_info = @cp_info_list[index - 1]
      cp_info.info if cp_info
    end
  end
end