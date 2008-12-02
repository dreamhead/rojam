module RBits
  class Base
    include Sequential
    
    def initialize
      yield self if block_given?
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
        fd.descriptor.write(bytes_io, __fields__[fd.field_id])
      end
    end
    
    def read_with_bytes_io(bytes_io)
      self.class.field_descriptors.each do |fd|
        begin
          __fields__[fd.field_id] = fd.descriptor.read(bytes_io)
        rescue Exception => e
          raise "Exception for [#{fd.field_id}] with [#{e.message}]"
        end
      end
    end
  end
end