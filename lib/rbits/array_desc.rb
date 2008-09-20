module RBits
  class Array < TypeDescriptor
    class << self
      attr_reader :read_size_proc, :write_size_proc, 
        :size_descriptor, :value_descriptor
    
      def values options
        @value_descriptor = TypeDescriptor.create_field(options[:type])
      end
    
      def size options
        @size_descriptor = TypeDescriptor.create_field(options[:type])
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
      size_from_io = self.class.size_descriptor.read(io)
      size = actual_read_size(size_from_io)
      array = []
      size.times do
        array << self.class.value_descriptor.read(io)
      end
      array
    end
  
    private
    def actual_write_size size
      self.class.write_size_proc.call(size)
    end
  
    def actual_read_size size
      self.class.read_size_proc.call(size)
    end
  end
end