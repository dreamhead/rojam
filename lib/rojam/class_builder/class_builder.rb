module Rojam
  class ClassBuilder
    class << self
      def build class_name, super_name = "java.lang.Object", &block
        cb = ClassBuilder.new(class_name, path(super_name))
        cb.instance_eval(&block) if block_given?
        cb
      end
      
      private
      def path(type_name)
        type_name.gsub('.', '/')
      end
    end
    
    private
    def initialize class_name, super_name
      @class_node = ClassNode.new do |node|
        node.name = class_name
        node.super_name = super_name
      end
    end
    
    public
    def constructor &block
      builder = MethodBuilder.build("<init>", "()V", &block)
      @class_node.methods << builder.to_node
    end
    
    def to_node
      @class_node
    end
  end
  
  class MethodBuilder
    class << self
      def build(name, desc)
        MethodBuilder.new(name, desc)
      end
    end
    
    def initialize name, desc
      @method_node = MethodNode.new do |node|
        node.name = name
        node.desc = desc
      end
    end
    
    def to_node
      @method_node
    end
  end
end