module RBits
  class Base
    include Sequential
    
    class << self
      def field_desc_added field_id
        define_method(field_id) do 
          @fields[field_id]
        end
        
        define_method("#{field_id}=") do |value|
          @fields[field_id] = value
        end
      end
    end
    
    def initialize
      @fields = {}
    end
    
    def write(io)
      write_with_bytes_io(BytesIOWrapper.new(io))
    end
    
    def read(io)
      read_with_bytes_io(BytesIOWrapper.new(io))
    end
    
    def read_bytes(bytes)
      read_with_bytes_io(BytesIO.new(bytes))
    end
    
    private
    def write_with_bytes_io(bytes_io)
      self.class.field_descriptors.each do |fd|
        fd.descriptor.write(bytes_io, @fields[fd.field_id])
      end
    end
    
    def read_with_bytes_io(bytes_io)
      self.class.field_descriptors.each do |fd|
        @fields[fd.field_id] = fd.descriptor.read(bytes_io)
      end
    end
  end
end