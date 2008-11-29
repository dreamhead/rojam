require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::Instruction do
  it 'compares instruction with opcode' do
    first_insn = Rojam::Instruction.new(Rojam::Opcode::RETURN)
    second_insn = Rojam::Instruction.new(Rojam::Opcode::RETURN)
    first_insn.should == first_insn
    first_insn.should == second_insn

    another_insn = Rojam::Instruction.new(Rojam::Opcode::ICONST_1)
    another_insn.should_not == first_insn
  end

  it 'fails to compare instruction with another kind of instruction' do
    method_insn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    instruction = Rojam::Instruction.new(Rojam::Opcode::INVOKESPECIAL)
    
    instruction.should_not == method_insn
  end

  it 'compares method instruction' do
    first_method_insn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    second_method_insn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V")
    first_method_insn.should == first_method_insn
    second_method_insn.should == second_method_insn

    anotherMethodInsn = Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/String", "<init>", "()V")
    first_method_insn.should_not == anotherMethodInsn
  end

  it 'compares field instruction' do
    first_field_insn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;")
    second_field_insn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;")
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "BasicClass", "text", "Ljava/lang/String;")
    first_field_insn.should_not == another_field_insn
  end

  it 'compares jump instruction' do
    first_field_insn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 3)
    second_field_insn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 3)
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 4)
    first_field_insn.should_not == another_field_insn
  end

  it 'compares ldc instruction' do
    first_field_insn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 3)
    second_field_insn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 3)
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::LdcInsn.new(Rojam::Opcode::LDC, 4)
    first_field_insn.should_not == another_field_insn
  end

  it 'compares int instruction' do
    first_field_insn = Rojam::IntInsn.new(Rojam::Opcode::LDC, 3)
    second_field_insn = Rojam::IntInsn.new(Rojam::Opcode::LDC, 3)
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::IntInsn.new(Rojam::Opcode::LDC, 4)
    first_field_insn.should_not == another_field_insn
  end

  it 'compares iinc instruction' do
    first_field_insn = Rojam::IincInsn.new(Rojam::Opcode::IINC, 1, 1)
    second_field_insn = Rojam::IincInsn.new(Rojam::Opcode::IINC, 1, 1)
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::IincInsn.new(Rojam::Opcode::IINC, 2, 1)
    first_field_insn.should_not == another_field_insn
  end

  it 'compares var instruction' do
    first_field_insn = Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1)
    second_field_insn = Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1)
    first_field_insn.should == first_field_insn
    second_field_insn.should == second_field_insn

    another_field_insn = Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 2)
    first_field_insn.should_not == another_field_insn
  end
end