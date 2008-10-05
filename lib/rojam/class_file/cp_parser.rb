module Rojam
  module CpParser
    def class_name index
      name_index = constant_value(index).name_index
      constant_value(name_index)
    end
    
    def method_owner_name index
      class_name(constant_value(index).class_index)
    end
    
    def name_and_desc index
      name_and_type_index = constant_value(index).name_and_type_index
      value = constant_value(name_and_type_index)
      [constant_value(value.name_index), constant_value(value.descriptor_index)]
    end
  end
end