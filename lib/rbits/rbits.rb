class RBits
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
    self.class.field_descriptors.each do |fd|
      fd.descriptor.write(io, @fields[fd.field_id])
    end
  end
  
  def read(io)
    self.class.field_descriptors.each do |fd|
      @fields[fd.field_id] = fd.descriptor.read(io)
    end
  end
end