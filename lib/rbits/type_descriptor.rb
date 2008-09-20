module RBits
  class TypeDescriptor
    @@field_types = {}
  
    class << self
      def field_type name
        @@field_types[name] = self
        Sequential.define_field_type(name)
      end
    
      def has_field_type?(name)
        not @@field_types[name].nil?
      end
    
      def create_field(name, options = {})
        type = @@field_types[name]
        raise "unknown field type: #{name}" unless type
        type.new(options)
      end
    end
  end
end