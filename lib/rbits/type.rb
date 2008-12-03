module RBits
  class Type
    @@field_types = {}
  
    class << self
      def slots_in_array(size)
        @slots_in_array = size
      end

      def __slots_in_array__
        @slots_in_array ||= 1
      end

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
      
      [:array, :string, :struct, :switch].each do |type_name|
        class_eval %Q{
          def #{type_name}(name, &block)
            type(name, RBits.const_get(:#{type_name.to_s.capitalize}), &block) 
          end
        }
      end
      
      def type(name, super_type, &block)
        klass = Class.new(super_type)
        klass.instance_eval(&block) if block_given?
        field_type(name, klass)
      end
    end

    def slots_in_array
      self.class.__slots_in_array__
    end
  end
end