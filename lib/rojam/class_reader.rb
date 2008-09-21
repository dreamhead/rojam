module Rojam
  class ClassReader
    def read(io)
      file = ClassFile.new
      file.read(io)
      file.to_node
    end
  end
end