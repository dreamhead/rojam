require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/constant_pool_reader_stub')

describe Rojam::ConstantPoolReader do
  describe 'Constant pool for Blank' do
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
      @reader = Rojam::ConstantPoolReader.new(constant_info_array)
    end

    it "retrives class name" do
      @reader.type_name(0x02).should == 'Blank'
    end
  
    it "retrives method owner name" do
      @reader.method_owner_name(0x01).should == 'java/lang/Object'
    end
  
    it "retrives name and desc" do
      name, desc = @reader.name_and_desc(0x01)
      name.should == '<init>'
      desc.should == '()V'
    end
  end

  describe 'constant pool helper with stub' do
    before(:each) do
      @pool = ConstantPoolReaderStub.new
    end

    it 'parses string' do
      @pool.constants({
          3 => Struct.new(:string_index).new(0x12),
          0x12 => 'Hello, World!'
        })

      @pool.string_value(3).should == 'Hello, World!'
      @pool.value(3).should == 'Hello, World!'
    end

    it 'parses int' do
      @pool.infoes({
          0x07 => Struct.new(:tag, :info).new(3, Struct.new(:bytes).new(0x05)),
        })
      @pool.int_value(0x07).should == 5
      @pool.value(0x07).should == 5
    end
  end
end