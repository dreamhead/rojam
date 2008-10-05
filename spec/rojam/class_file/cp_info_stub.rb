module CpInfoStub
  def clear_constants
    cp_table.clear
  end
  
  def add_constant(index, value)
    cp_table[index] = value
  end
  
  def add_constants values
    cp_table.merge!(values)
  end
  
  def constant_value(index)
    cp_table[index]
  end
  
  def cp_table
    @cp_table ||= {}
  end
end