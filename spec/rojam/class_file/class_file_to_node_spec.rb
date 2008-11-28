require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFile do
  describe 'to_node' do
    before(:all) do
      java_class = Rojam::ClassFile.new
      File.open(File.dirname(__FILE__) + "/fixtures/CommonClass.class", "rb") do |f|
        java_class.read(f)
      end
      @node = java_class.to_node
    end
    
    it "creates node with version" do
      @node.version.should == Rojam::Java::Versions::V1_6
    end
    
    it "creates node with access" do
      @node.access.should == 
        Rojam::Java::Access::ACC_PUBLIC | Rojam::Java::Access::ACC_SUPER
    end
    
    it "creates node with name" do
      @node.name.should == "CommonClass"
    end
    
    it "creates node with super name" do
      @node.super_name.should == "java/lang/Object"
    end
    
    it "creates node with interfaces" do
      @node.interfaces.should have(1).items
      @node.interfaces[0].should == 'CommonInterface'
    end
    
    it "creates node with fields" do
      @node.fields.should have(3).items
      string_constant_field = @node.fields[0]
      string_constant_field.access.should ==
        Rojam::Java::Access::ACC_PRIVATE | Rojam::Java::Access::ACC_STATIC | Rojam::Java::Access::ACC_FINAL
      string_constant_field.name.should == 'CONSTANT'
      string_constant_field.desc.should == 'Ljava/lang/String;'
      string_constant_field.signature.should be_nil
      string_constant_field.value.should == 'constant'

      int_constant_field = @node.fields[1]
      int_constant_field.access.should ==
        Rojam::Java::Access::ACC_PRIVATE | Rojam::Java::Access::ACC_STATIC | Rojam::Java::Access::ACC_FINAL
      int_constant_field.name.should == 'INT'
      int_constant_field.desc.should == 'I'
      int_constant_field.signature.should be_nil
      int_constant_field.value.should == 5

      instance_field = @node.fields[2]
      instance_field.access.should == Rojam::Java::Access::ACC_PRIVATE
      instance_field.name.should == 'text'
      instance_field.desc.should == 'Ljava/lang/String;'
      instance_field.signature.should be_nil
      instance_field.value.should be_nil
    end
    
    it "creates node with methods" do
      @node.methods.should have(4).items
      constructor = @node.methods[0]
      constructor.access.should == Rojam::Java::Access::ACC_PUBLIC
      constructor.name.should == '<init>'
      constructor.desc.should == '()V'
      constructor.max_stack.should == 1
      constructor.max_locals.should == 1
      constructor.line_number.should == 0x01
      constructor.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ALOAD_0),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V"),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]

      getter = @node.methods[1]
      getter.access.should == Rojam::Java::Access::ACC_PUBLIC
      getter.name.should == 'getText'
      getter.desc.should == '()Ljava/lang/String;'
      getter.max_stack.should == 1
      getter.max_locals.should == 1
      getter.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ALOAD_0),
        Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;"),
        Rojam::Instruction.new(Rojam::Opcode::ARETURN)
      ]

      assignment = @node.methods[2]
      assignment.access.should == Rojam::Java::Access::ACC_PUBLIC
      assignment.name.should == 'assignment'
      assignment.desc.should == '()V'
      assignment.max_stack.should == 1
      assignment.max_locals.should == 3
      assignment.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::ISTORE_1),
        Rojam::Instruction.new(Rojam::Opcode::ILOAD_1),
        Rojam::Instruction.new(Rojam::Opcode::ISTORE_2),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]

      conditional = @node.methods[3]
      conditional.name.should == 'conditional'
      conditional.desc.should == '()V'
      conditional.max_stack.should == 2
      conditional.max_locals.should == 2
      conditional.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::ISTORE_1),
        Rojam::Instruction.new(Rojam::Opcode::ILOAD_1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, 3),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    it "creates node with attributes" do
      @node.source_file.should == "CommonClass.java"
    end
  end
end