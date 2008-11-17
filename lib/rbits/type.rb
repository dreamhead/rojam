module RBits
  class Type
    @@field_types = {}
  
    class << self
      def field_type name, type_class = self
        @@field_types[name] = type_class
        Sequential.define_field_type(name)
        type_class
      end
    
      def has_field_type?(name)
        not @@field_types[name].nil?
      end
    
      def create_field(name, options = {})
        type = @@field_types[name]
        raise "unknown field type: #{name}" unless type
        type.new(options)
      end
      
      def array(name, &block)
        type(name, RBits::Array, &block)        
      end
      
      def string(name, &block)
        type(name, RBits::String, &block) 
      end
      
      def struct(name, &block)
        type(name, RBits::Struct, &block)
      end
      
      def switch(name, &block)
        type(name, RBits::Switch, &block)
      end
      
      def type(name, super_type, &block)
        klass = Class.new(super_type)
        klass.instance_eval(&block) if block_given?
        field_type(name, klass)
      end
    end
  end
end