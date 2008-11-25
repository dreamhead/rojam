require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/constant_pool_reader_stub')

describe Rojam::AttributeParser do
  before(:each) do
    @pool = ConstantPoolReaderStub.new
    @parser = Rojam::AttributeParser.new(@pool)
  end

  it 'parses attributes' do
    attributes = ['attr', 'attr']
    @parser.should_receive(:parse).twice
    @node = Rojam::MethodNode.new
    @parser.parse_attributes(attributes, @node)
  end

  it 'raises exception for unknown attribute' do
    @node = Rojam::MethodNode.new
    lambda { @parser.parse_attribute('Unknown', [0x00], @node) }.should raise_error
  end

  describe 'Method Attribute' do
    before(:each) do
      @node = Rojam::MethodNode.new
    end
    
    it 'parses LineNumberTable' do
      @parser.parse_attribute('LineNumberTable', [0x00, 0x01, 0x00, 0x00, 0x00, 0x01], @node)
      @node.start_pc.should == 0x00
      @node.line_number.should == 0x01
    end

    it 'parses Code' do
      @pool.constants({
          1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
          2 => "java/lang/Object",
          3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
          4 => "<init>",
          5 => "()V",
          6 => Struct.new(:name_index).new(0x02)
        })
      @parser.parse_attribute('Code',
        [0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05, 0x2A, 0xB7,
          0x00, 0x01, 0xB1, 0x00, 0x00, 0x00, 0x00],
        @node)
      @node.max_stack.should == 0x01
      @node.max_locals.should == 0x01
    end
  end

  describe 'Field Attribute' do
    before(:each) do
      @node = Rojam::FieldNode.new
    end

    it 'parses ConstantValue' do
      @pool.constants({
          0x07 => Struct.new(:string_index).new(0x12),
          0x12 => 'constant',
        })
      @parser.parse_attribute('ConstantValue', [0x00, 0x07], @node)
      @node.value.should == 'constant'
    end
  end

  describe 'Class Attribute' do
    before(:each) do
      @node = Rojam::ClassNode.new
    end

    it 'parses SourceFile' do
      @pool.constants(0x09 => "Blank.java")
      @parser.parse_attribute('SourceFile', [0x00, 0x09], @node)
      @node.source_file.should == 'Blank.java'
    end
  end
end