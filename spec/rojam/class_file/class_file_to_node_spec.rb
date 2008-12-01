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

    def compare_constructor constructor
      constructor.access.should == Rojam::Java::Access::ACC_PUBLIC
      constructor.name.should == '<init>'
      constructor.desc.should == '()V'
      constructor.max_stack.should == 1
      constructor.max_locals.should == 1
      constructor.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ALOAD_0),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V"),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_getter getter
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
    end

    def compare_assignment assignment
      assignment.access.should == Rojam::Java::Access::ACC_PUBLIC
      assignment.name.should == 'assignment'
      assignment.desc.should == '()V'
      assignment.max_stack.should == 1
      assignment.max_locals.should == 3
      assignment.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 2),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_conditional conditional
      conditional.name.should == 'conditional'
      conditional.desc.should == '()V'
      conditional.max_stack.should == 2
      conditional.max_locals.should == 2
      jump_label = Rojam::Label.new
      jump_label.line = 19
      goto_label = Rojam::Label.new
      goto_label.line = 24
      second_jump_label = Rojam::Label.new
      second_jump_label.line = 22
      second_goto_label = Rojam::Label.new
      second_goto_label.line = 24

      conditional.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_M1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, jump_label),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_2),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, goto_label),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_2),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, second_jump_label),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_3),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, second_goto_label),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_4),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_loop loop
      loop.access.should == Rojam::Java::Access::ACC_PUBLIC
      loop.name.should == 'loop'
      loop.desc.should == '()V'
      loop.max_stack.should == 2
      loop.max_locals.should == 2

      jump_label = Rojam::Label.new
      jump_label.line = 29
      goto_label = Rojam::Label.new

      loop.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::IntInsn.new(Rojam::Opcode::BIPUSH, 10),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPGE, jump_label),
        Rojam::IincInsn.new(Rojam::Opcode::IINC, 1, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, goto_label),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_arith arith
      arith.access.should == Rojam::Java::Access::ACC_PUBLIC
      arith.name.should == 'arith'
      arith.desc.should == '()V'
      arith.max_stack.should == 2
      arith.max_locals.should == 6

      arith.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_5),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::IADD),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 2),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::ISUB),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 3),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::IMUL),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 4),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::IDIV),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 5),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_object object
      object.access.should == Rojam::Java::Access::ACC_PUBLIC
      object.name.should == 'object'
      object.desc.should == '()V'
      object.max_stack.should == 2
      object.max_locals.should == 3
      object.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ACONST_NULL),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 1),
        Rojam::TypeInsn.new(Rojam::Opcode::NEW, 'java/lang/Object'),
        Rojam::Instruction.new(Rojam::Opcode::DUP),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V"),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 2),
        Rojam::Instruction.new(Rojam::Opcode::RETURN),
      ]
    end
    
    it "creates node with methods" do
      @node.methods.should have(7).items
      compare_constructor(@node.methods[0])
      compare_getter(@node.methods[1])
      compare_assignment(@node.methods[2])
      compare_conditional(@node.methods[3])
      compare_loop(@node.methods[4])
      compare_arith(@node.methods[5])
      compare_object(@node.methods[6])
    end

    it "creates node with attributes" do
      @node.source_file.should == "CommonClass.java"
    end
  end
end