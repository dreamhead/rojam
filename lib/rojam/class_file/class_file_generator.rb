module Rojam
  class ClassFileGenerator
    def generate class_node
      ClassFile.new do |file|
        file.magic = 0xCAFEBABE
        file.major_version = class_node.version
        file.minor_version = 0
        file.access_flags = class_node.access
        file.cp_info = []
        file.this_class = cp_class_name(file.cp_info, class_node.name)
        file.super_class = cp_class_name(file.cp_info, class_node.super_name)
      end
    end

    private
    CpClass = Struct.new(:info)

    def cp_class_name(cp_info, name)
      cp_info << CpClass.new(name)
      cp_info << CpClass.new(Struct.new(:name_index).new(cp_info.size))
      cp_info.size
    end
  end
end