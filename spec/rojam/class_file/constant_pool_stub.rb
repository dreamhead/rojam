require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class ConstantPoolStub
  include Rojam::ConstantPoolHelper
  
  def constant(index, value)
    cp_table[index] = value
  end
  
  def constants values
    cp_table.merge!(values)
  end
  
  def constant_value(index)
    cp_table[index]
  end
  
  def cp_table
    @cp_table ||= {}
  end
end