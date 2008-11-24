module Rojam
  class ClassFileGenerator
    def generate class_node
      ClassFile.new do |file|
        file.magic = 0xCAFEBABE
        file.major_version = class_node.version
        file.minor_version = 0
        file.access_flags = class_node.access
      end
    end
  end
end