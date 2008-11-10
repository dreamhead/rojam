require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/constant_pool_stub')

describe Rojam::AttributeParser do
  AttributeClass = Struct.new(:attribute_name_index, :infoes)
  
  before(:each) do
    @pool = ConstantPoolStub.new
    @parser = Rojam::AttributeParser.new(@pool)
  end
  
  it 'parses attributes' do
    node = Rojam::MethodNode.new
    attr = AttributeClass.new(0x06, [0x00, 0x01, 0x00, 0x01])
    attributes = [attr, attr]
    @parser.should_receive(:parse).twice
    @parser.parse_attributes(attributes, node)
  end
  
  it 'raises exception for unknown attribute' do
    node = Rojam::ClassNode.new
    source_file_index = 0x06
    attr = AttributeClass.new(source_file_index, [0x00, 0x09])
    @pool.constant(source_file_index, "Unknown")
    lambda { parser.parse(attr, node) }.should raise_error
  end
  
  it 'parses SourceFile attribute' do
    node = Rojam::ClassNode.new
    source_file_index = 0x06
    attr = AttributeClass.new(source_file_index, [0x00, 0x09])
    @pool.constants({source_file_index => "SourceFile", 0x09 => "Blank.java"})
    @parser.parse(attr, node)
    node.source_file.should == 'Blank.java'
  end
  
  it 'parses LineNumberTable' do
    node = Rojam::MethodNode.new
    line_number_table_index = 0x07
    attr = AttributeClass.new(line_number_table_index, [0x00, 0x01, 0x00, 0x00, 0x00, 0x01])
    @pool.constant(line_number_table_index, "LineNumberTable")
    @parser.parse(attr, node)
    node.start_pc.should == 0x00
    node.line_number.should == 0x01
  end
  
  it "parses Code attribute" do
    node = Rojam::MethodNode.new
    code_index = 0x07
    attr = AttributeClass.new(code_index,
      [0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05, 
       0x2A, 0xB7, 0x00, 0x01, 0xB1, 0x00, 0x00, 0x00,
       0x00])
    @pool.constants({
        1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
        2 => "java/lang/Object",
        3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
        4 => "<init>",
        5 => "()V",
        6 => Struct.new(:name_index).new(0x02),
        7 => "Code"
    })
    @parser.parse(attr, node)
    node.max_stack.should == 0x01
    node.max_locals.should == 0x01
  end
end