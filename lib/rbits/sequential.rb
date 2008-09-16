module Sequential
  def self.included(base)
    base.extend ClassMethods
  end
  
  def self.define_field_type symbol
    ClassMethods.send :define_method, symbol do |field_id, *args|
      options = args[0] || {}
      type_desc = TypeDescriptor.create_field(symbol, options)
      add_field_desc(field_id, type_desc)
    end
  end
  
  module ClassMethods
    FieldDescriptor = Struct.new(:field_id, :descriptor)
    
    def add_field_desc(field_id, type_desc)
      raise "duplicated defination for #{field_id}" if has_desc_for?(field_id)
      field_descriptors << FieldDescriptor.new(field_id, type_desc)
      
      field_desc_added(field_id) if respond_to? :field_desc_added
    end
    
    def has_desc_for?(field_id)
      field_descriptors.any? {|desc| desc.field_id == field_id }
    end
    
    def field_descriptors
      @field_descriptors ||= []
    end
  end
end