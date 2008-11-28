require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::Instruction do
  it 'compares instruction with opcode' do
    firstReturnInstruction = Rojam::Instruction.new(Rojam::Opcode::RETURN)
    secondReturnInstruction = Rojam::Instruction.new(Rojam::Opcode::RETURN)
    firstReturnInstruction.should == firstReturnInstruction
    firstReturnInstruction.should == secondReturnInstruction
  end

  it 'fails to compare instruction with another kind of instruction' do
    methodInsn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    instruction = Rojam::Instruction.new(Rojam::Opcode::INVOKESPECIAL)
    
    instruction.should_not == methodInsn
  end

  it 'compares method instruction' do
    firstMethodInsn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    secondMethodInsn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    firstMethodInsn.should == firstMethodInsn
    secondMethodInsn.should == secondMethodInsn

    anotherMethodInsn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/String", "<init>", "()V")
    firstMethodInsn.should_not == anotherMethodInsn
  end

  it 'compares field instruction' do
    firstFieldInsn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;")
    secondFieldInsn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;")
    firstFieldInsn.should == firstFieldInsn
    secondFieldInsn.should == secondFieldInsn

    anotherFieldInsn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "BasicClass", "text", "Ljava/lang/String;")
    firstFieldInsn.should_not == anotherFieldInsn
  end

  it 'compares jump instruction' do
    firstFieldInsn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 3)
    secondFieldInsn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 3)
    firstFieldInsn.should == firstFieldInsn
    secondFieldInsn.should == secondFieldInsn

    anotherFieldInsn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 4)
    firstFieldInsn.should_not == anotherFieldInsn
  end

  it 'compares ldc instruction' do
    firstFieldInsn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 3)
    secondFieldInsn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 3)
    firstFieldInsn.should == firstFieldInsn
    secondFieldInsn.should == secondFieldInsn

    anotherFieldInsn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 4)
    firstFieldInsn.should_not == anotherFieldInsn
  end
end

