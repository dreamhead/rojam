require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/constant_pool_stub')

describe Rojam::InstructionParser do
  before(:each) do
    @pool = ConstantPoolStub.new
    @parser = Rojam::InstructionParser.new @pool
  end

  it "parses ALOAD_0" do
    instruction, consumed_byte_size = @parser.parse_instruction([0x2A])
    instruction.opcode.should == Rojam::Opcode::ALOAD_0
  end
  
  it "parses ALOAD_0 sequentially" do
    node = Rojam::MethodNode.new
    @parser.parse(node, [0x2A, 0x2A])
    node.instructions.should have(2).items
    node.instructions[0].opcode.should == Rojam::Opcode::ALOAD_0
    node.instructions[1].opcode.should == Rojam::Opcode::ALOAD_0
  end
  
  it 'parses INVOKESPECIAL' do
    @pool.constants({
        1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
        2 => "java/lang/Object",
        3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
        4 => "<init>",
        5 => "()V",
        6 => Struct.new(:name_index).new(0x02)
    })

    instruction, consumed_byte_size = @parser.parse_instruction([0xB7, 0x00, 0x01])
    instruction.opcode.should == Rojam::Opcode::INVOKESPECIAL
    consumed_byte_size.should == 3
    instruction.owner.should == "java/lang/Object"
    instruction.name.should == "<init>"
    instruction.desc.should == "()V"
  end
end