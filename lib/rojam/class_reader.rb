module Rojam
  class ClassReader
    def read(io)
      file = ClassFile.new {|class_file| class_file.read(io) }
      file.to_node
    end
  end
end