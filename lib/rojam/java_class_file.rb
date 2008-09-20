class Interfaces < ArrayDesc
  size :type => :u2
  values :type => :u2
  
  field_type :interfaces
end

class Info < ArrayDesc
  size :type => :u4
  values :type => :u1
  
  field_type :info
end

class AttributeInfo < StructDesc
  u2 :attribute_name_index
  info :infoes
  
  field_type :attribute_info
end

class Attributes < ArrayDesc
  size :type => :u2
  values :type => :attribute_info
  
  field_type :attributes
end

class FieldInfo < StructDesc
  u2 :access_flags
  u2 :name_index
  u2 :descriptor_index
  attributes :attributes
  
  field_type :field_info
end

class Fileds < ArrayDesc
  size :type => :u2
  values :type => :field_info
  
  field_type :fields
end

class MethodInfo < StructDesc
  u2 :access_flags
  u2 :name_index
  u2 :descriptor_index
  attributes :attributes
  
  field_type :method_info
end

class Methods < ArrayDesc
  size :type => :u2
  values :type => :method_info
  
  field_type :methods
end

class ClassFile < RBits
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
end