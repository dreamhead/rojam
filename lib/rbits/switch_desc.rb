module RBits
  class Switch < TypeDescriptor
    class << self
      attr_reader :tag_name, :tag_descriptor, :value_name, :value_types
      attr_accessor :value_descriptors
    
      def tag(name, options)
        @tag_name = name
        @tag_descriptor = TypeDescriptor.create_field(options[:type])
      end
    
      def value(name, options)
        @value_name = name
        @value_types = options[:types]
      end
    end

    def initialize(options = {})
      @object_class = ::Struct.new(self.class.tag_name, self.class.value_name)
    end
  
    def write(io, object)
      tag = object.send(self.class.tag_name)
      self.class.tag_descriptor.write(io, tag)
      value_descriptor(tag).write(io, object.send(self.class.value_name))
    end
  
    def read(io)
      tag = self.class.tag_descriptor.read(io)
      value = value_descriptor(tag).read(io)
      @object_class.new(tag, value)
    end
  
    private
    def value_descriptor(value)
      type = value_type(value)
      value_descriptors[type] ||= TypeDescriptor.create_field(type)
    end
  
    def value_type(value)
      item_type = self.class.value_types[value]
      item_type ||= (raise "Unknown reference value #{value}")
    end
  
    def value_descriptors
      self.class.value_descriptors ||= {}
    end
  end
end