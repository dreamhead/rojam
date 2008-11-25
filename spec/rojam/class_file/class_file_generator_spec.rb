require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFileGenerator do
  before(:all) do
    File.open(File.dirname(__FILE__) + "/fixtures/CommonClass.class", "rb") do |f|
      node = Rojam::ClassReader.new.read(f)
      @class_file = Rojam::ClassFileGenerator.new.generate(node)
      @reader = Rojam::ConstantPoolReader.new(@class_file.cp_info)
    end
  end

  it 'generates class file with magic number' do
    @class_file.magic.should == 0xCAFEBABE
  end

  it 'generates class file with version' do
    @class_file.major_version.should == Rojam::Java::Versions::V1_6
    @class_file.minor_version.should == 0
  end

  it 'generates class file with access flags' do
    @class_file.access_flags.should == Rojam::Java::Access::ACC_PUBLIC | Rojam::Java::Access::ACC_SUPER
  end

  it 'generates this class in constant pool' do
    @reader.type_name(@class_file.this_class).should == 'CommonClass'
  end

  it 'generates super class in constant pool' do
    @reader.type_name(@class_file.super_class).should == 'java/lang/Object'
  end

  it 'generates interfaces' do
    @reader.type_name(@class_file.interfaces[0]).should == 'CommonInterface'
  end
end