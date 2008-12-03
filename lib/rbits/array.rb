module RBits
  class Array < Type
    class << self
      attr_reader :read_size_proc, :write_size_proc, 
        :size_descriptor, :value_descriptor
    
      def values options
        @value_descriptor = Type.create_field(options[:type])
      end
    
      def size options
        @size_descriptor = Type.create_field(options[:type])
        @read_size_proc = options[:read_proc] || lambda {|size| size }
        @write_size_proc = options[:write_proc] || lambda {|size| size }
      end
    end
  
    def initialize(options = {})
    end
  
    def write(io, array)
      size_to_io = actual_write_size(array.size)
      self.class.size_descriptor.write(io, size_to_io)
      array.each do |value|
        self.class.value_descriptor.write(io, value)
      end
    end
  
    def read(io)
      size = read_size(io)
      read_array(size, io)
    end
  
    private
    def actual_write_size size
      self.class.write_size_proc.call(size)
    end
  
    def actual_read_size size
      self.class.read_size_proc.call(size)
    end

    def read_size(io)
      size_from_io = self.class.size_descriptor.read(io)
      actual_read_size(size_from_io)
    end

    def read_array(size, io)
      array = []
      i = 0

      desc = self.class.value_descriptor

      while (i < size)
        array[i] = desc.read(io)
        i += slots(array[i])
      end
      
      array
    end

    def slots(value)
      slots_value(value) || 1
    end

    def slots_value(value)
      value.respond_to?(:slots_in_array) && value.slots_in_array
    end
  end
end