require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ConstantPool do
  before(:all) do
    CpInfoClass = Struct.new(:info)
    constant_info_array = [
      CpInfoClass.new(Struct.new(:class_index, :name_and_type_index).new(0x03, 0x0A)),
      CpInfoClass.new(Struct.new(:name_index).new(0x0B)),
      CpInfoClass.new(Struct.new(:name_index).new(0x0C)),
      CpInfoClass.new('<init>'),
      CpInfoClass.new('()V'),
      CpInfoClass.new('Code'),
      CpInfoClass.new('LineNumberTable'),
      CpInfoClass.new('SourceFile'),
      CpInfoClass.new('Blank.java'),
      CpInfoClass.new(Struct.new(:name_index, :descriptor_index).new(0x04, 0x05)),
      CpInfoClass.new('Blank'),
      CpInfoClass.new('java/lang/Object')
    ]
    @constant_pool = Rojam::ConstantPool.new(constant_info_array)
  end

  it "retrives class name" do
    @constant_pool.class_name(0x02).should == 'Blank'
  end
  
  it "retrives method owner name" do
    @constant_pool.method_owner_name(0x01).should == 'java/lang/Object'
  end
  
  it "retrives name and desc" do
    name, desc = @constant_pool.name_and_desc(0x01)
    name.should == '<init>'
    desc.should == '()V'
  end
end