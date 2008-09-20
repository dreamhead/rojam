class CONSTANT_Utf8 < StringDesc
  size :type => :u2
  
  field_type :constant_utf8
end

class CONSTANT_Class < StructDesc
  u2 :name_index
  
  field_type :constant_class
end

class CONSTANT_Fieldref < StructDesc
  u2 :class_index
  u2 :name_and_type_index
  
  field_type :constant_fieldref
end

class CONSTANT_Methodref < StructDesc
  u2 :class_index
  u2 :name_and_type_index
  
  field_type :constant_methodref
end

class CONSTANT_NameAndType < StructDesc
  u2 :name_index
  u2 :descriptor_index
  
  field_type :constant_name_and_type
end

class CpInfo < SwitchDesc
  tag :tag, :type => :u1
  value :info, :types => {
    1   => :constant_utf8,
    7   => :constant_class,
    10  => :constant_methodref,
    12  =>:constant_name_and_type
  }
  
  field_type :cp_info
end

class CpInfoArray < ArrayDesc
  size :type => :u2, 
    :read_proc => lambda {|size| size - 1 }, 
    :write_proc => lambda {|size| size + 1 }
  values :type => :cp_info
  
  field_type :cp_info_array
end