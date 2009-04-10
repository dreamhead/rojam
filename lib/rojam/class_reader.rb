module Rojam
  class ClassReader
    def read(io)
      file = ClassFile.read(io)
      file.to_node
    end
  end
end