require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

class ConstantPoolReaderStub
  include Rojam::ConstantPoolReaderHelper
  
  def constants values
    values.each {|key, value| cp_table[key] = Struct.new(:tag, :info).new(:default, value)}
  end

  def infoes infoes
    cp_table.merge!(infoes)
  end

  def constant_info(index)
    cp_table[index]
  end
  
  def constant_value(index)
    cp_table[index].info if cp_table[index]
  end
  
  def cp_table
    @cp_table ||= {}
  end
end