class StructDesc < TypeDescriptor
  include Sequential
  
  def initialize(options = {})
    field_ids = self.class.field_descriptors.collect {|desc| desc.field_id }
    @object_class = Struct.new(*field_ids)
  end
  
  def write(io, value)
    self.class.field_descriptors.each do |fd|
      fd.descriptor.write(io, value.send(fd.field_id))
    end
  end
  
  def read(io)
    target = @object_class.new
    self.class.field_descriptors.each do |fd|
      target.send("#{fd.field_id}=", fd.descriptor.read(io))
    end
    target
  end
end
