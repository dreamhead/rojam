require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/cp_info_stub')

describe Rojam::AttributeParser do
  include Rojam::AttributeParser
  include CpInfoStub
  
  AttributeClass = Struct.new(:attribute_name_index, :infoes)
  
  after(:each) do
    clear_constants
  end
  
  it 'parses attributes' do
    node = Rojam::MethodNode.new
    attr = AttributeClass.new(0x06, [0x00, 0x01, 0x00, 0x01])
    attributes = [attr, attr]
    self.should_receive(:parse_attribute).twice
    parse_attributes(attributes, node)
  end
  
  it 'raises exception for unknown attribute' do
    node = Rojam::ClassNode.new
    source_file_index = 0x06
    attr = AttributeClass.new(source_file_index, [0x00, 0x09])
    add_constant(source_file_index, "Unknown")
    lambda { parse_attribute(attr, node) }.should raise_error
  end
  
  it "parses Code attribute" do
    node = Rojam::MethodNode.new
    code_index = 0x07
    attr = AttributeClass.new(code_index,
      [0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05, 
       0x2A, 0xB7, 0x00, 0x01, 0xB1, 0x00, 0x00, 0x00,
       0x00])
    add_constants({
        1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
        2 => "java/lang/Object",
        3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
        4 => "<init>",
        5 => "()V",
        6 => Struct.new(:name_index).new(0x02),
        7 => "Code"
    })
    parse_attribute(attr, node)
    node.max_stack.should == 0x01
    node.max_locals.should == 0x01
  end
  
  it "parses SourceFile attribute" do
    node = Rojam::ClassNode.new
    source_file_index = 0x06
    attr = AttributeClass.new(source_file_index, [0x00, 0x09])
    add_constants({source_file_index => "SourceFile", 0x09 => "Blank.java"})
    parse_attribute(attr, node)
    node.source_file.should == 'Blank.java'
  end
  
  it "parses LineNumberTable" do
    node = Rojam::MethodNode.new
    line_number_table_index = 0x07
    attr = AttributeClass.new(line_number_table_index, [0x00, 0x01, 0x00, 0x00, 0x00, 0x01])
    add_constant(line_number_table_index, "LineNumberTable")
    parse_attribute(attr, node)
    node.start_pc.should == 0x00
    node.line_number.should == 0x01
  end
end