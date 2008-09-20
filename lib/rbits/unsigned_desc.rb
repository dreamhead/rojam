module RBits
  class Unsigned < TypeDescriptor
    def initialize(size, options = {})
      @size = size
      @template = "C#{@size}"
      @default_value = options[:default] ||0
      @constant = options[:const]
    end
  
    def write(io, value)
      current_value = value_to_write(value)
      target = unsigned_to_array(current_value)
      io.write(target.pack(@template))
    end
  
    def read(io)
      source_from_io = io.read(@size)
      raise 'nothing read from source' unless source_from_io
      unpack_array = source_from_io.unpack(@template)
      current_value = array_to_unsigned(unpack_array)
      raise "expected constant #{@constant} but #{current_value}" if valid_read_value?(current_value)
      current_value
    end
  
    private
  
    BITS_IN_BYTE = 8
  
    def unsigned_to_array(value)
      targets = []
      @size.times do
        targets << (value & 0xFF)
        value >>= BITS_IN_BYTE
      end
      targets.reverse
    end
  
    def array_to_unsigned(array)
      current_value = 0
      array.each do |value|
        current_value <<= BITS_IN_BYTE
        current_value |= value
      end
      current_value
    end
  
    def valid_read_value?(value)
      @constant && @constant != value
    end
  
    def value_to_write(value)
      @constant || value || @default_value
    end
  end

  [1, 2, 4, 8].each do |size|
    eval <<-EOMETHODEF
    class U#{size} < Unsigned
      field_type :u#{size}

      def initialize(options)
        super(#{size}, options)
      end
    end
    EOMETHODEF
  end
end