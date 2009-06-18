require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFile do
  describe 'to_node' do
    
    before(:all) do
      File.open(File.dirname(__FILE__) + "/fixtures/CommonClass.class", "rb") do |f|
        java_class = Rojam::ClassFile.read(f)
        @node = java_class.to_node
      end
      # Everytime we add a line to the Java code, the label value in the JumpInsn which locates in the method below the line added will be changed
      # so we add a variable here presenting how many lines are added above all the methods, note that when you add a line to CommanClass.java
      # above all the methods, you should add the variable by 1
      @all_methods_off_set = 2
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
      @node.fields.should have(6).items
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

      long_constant_field = @node.fields[2]
      long_constant_field.access.should ==
        Rojam::Java::Access::ACC_PRIVATE | Rojam::Java::Access::ACC_STATIC | Rojam::Java::Access::ACC_FINAL
      long_constant_field.name.should == 'LONG'
      long_constant_field.desc.should == 'J'
      long_constant_field.signature.should be_nil
      long_constant_field.value.should == 10

      instance_field = @node.fields[3]
      instance_field.access.should == Rojam::Java::Access::ACC_PRIVATE
      instance_field.name.should == 'text'
      instance_field.desc.should == 'Ljava/lang/String;'
      instance_field.signature.should be_nil
      instance_field.value.should be_nil
      
      float_constant_field = @node.fields[4]
      float_constant_field.access.should == Rojam::Java::Access::ACC_PRIVATE | Rojam::Java::Access::ACC_STATIC | Rojam::Java::Access::ACC_FINAL
      float_constant_field.name.should == 'FLOAT'
      float_constant_field.desc.should == 'F'
      float_constant_field.signature.should be_nil
      float_constant_field.value.should == 3.5
      
      arraylist_field = @node.fields[5]
      arraylist_field.access.should == Rojam::Java::Access::ACC_PRIVATE
      arraylist_field.name.should == 'theArrayList'
      arraylist_field.desc.should == 'Ljava/util/ArrayList;'
      arraylist_field.signature.should == "Ljava/util/ArrayList<Ljava/lang/String;>;"
      arraylist_field.value.should be_nil
    end

    def compare_constructor constructor
      constructor.access.should == Rojam::Java::Access::ACC_PUBLIC
      constructor.name.should == '<init>'
      constructor.desc.should == '()V'
      constructor.exceptions.should be_empty
      constructor.max_stack.should == 3
      constructor.max_locals.should == 1
      
      constructor.instructions.should == [
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 0),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V"),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 0),
        Rojam::TypeInsn.new(Rojam::Opcode::NEW, "java/util/ArrayList"),
        Rojam::Instruction.new(Rojam::Opcode::DUP),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/util/ArrayList", "<init>", "()V"),
        Rojam::FieldInsn.new(Rojam::Opcode::PUTFIELD, "CommonClass","theArrayList","Ljava/util/ArrayList;"),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_getter getter
      getter.access.should == Rojam::Java::Access::ACC_PUBLIC
      getter.name.should == 'getText'
      getter.desc.should == '()Ljava/lang/String;'
      getter.exceptions.should be_empty
      getter.max_stack.should == 1
      getter.max_locals.should == 1
      getter.instructions.should == [
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 0),
        Rojam::FieldInsn.new(Rojam::Opcode::GETFIELD, "CommonClass", "text", "Ljava/lang/String;"),
        Rojam::Instruction.new(Rojam::Opcode::ARETURN)
      ]
    end

    def compare_assignment assignment
      assignment.access.should == Rojam::Java::Access::ACC_PUBLIC
      assignment.name.should == 'assignment'
      assignment.desc.should == '()V'
      assignment.exceptions.should be_empty
      assignment.max_stack.should == 1
      assignment.max_locals.should == 4
      assignment.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 2),
        Rojam::LdcInsn.new(Rojam::Opcode::LDC, 8),
        Rojam::VarInsn.new(Rojam::Opcode::FSTORE,3),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end
    
    def compare_return_for_arraylist arraylist
      arraylist.access.should == Rojam::Java::Access::ACC_PUBLIC
      arraylist.name.should == 'return_for_arraylist'
      arraylist.desc.should == '()Ljava/util/ArrayList;'
      arraylist.signature.should == "()Ljava/util/ArrayList<Ljava/lang/Integer;>;"
      arraylist.exceptions.should be_empty
      arraylist.max_stack.should == 2
      arraylist.max_locals.should == 1
      
      arraylist.instructions.should == [
        Rojam::TypeInsn.new(Rojam::Opcode::NEW, "java/util/ArrayList"),
        Rojam::Instruction.new(Rojam::Opcode::DUP),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/util/ArrayList","<init>","()V"),
        Rojam::Instruction.new(Rojam::Opcode::ARETURN)
      ]
    end
    
    def compare_use_arraylist arraylist
      arraylist.access.should == Rojam::Java::Access::ACC_PUBLIC
      arraylist.name.should == 'use_arraylist'
      arraylist.desc.should == '()V'
      arraylist.signature.should be_nil
      arraylist.exceptions.should be_empty
      arraylist.max_stack.should == 2
      arraylist.max_locals.should == 3
      
      arraylist.instructions.should == [
        Rojam::TypeInsn.new(Rojam::Opcode::NEW, "java/util/ArrayList"),
        Rojam::Instruction.new(Rojam::Opcode::DUP),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/util/ArrayList","<init>","()V"),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESTATIC, "java/lang/Integer","valueOf","(I)Ljava/lang/Integer;"),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKEVIRTUAL, "java/util/ArrayList","add","(Ljava/lang/Object;)Z"),
        Rojam::Instruction.new(Rojam::Opcode::POP),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKEVIRTUAL, "java/util/ArrayList","get","(I)Ljava/lang/Object;"),
        Rojam::TypeInsn.new(Rojam::Opcode::CHECKCAST, "java/lang/Integer"),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 2),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_conditional conditional
      conditional.access.should == Rojam::Java::Access::ACC_PUBLIC
      conditional.name.should == 'conditional'
      conditional.desc.should == '()V'
      conditional.exceptions.should be_empty
      conditional.max_stack.should == 2
      conditional.max_locals.should == 2

      conditional.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_M1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, Rojam::Label.new(67 + @all_methods_off_set)),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_2),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, Rojam::Label.new(27 + @all_methods_off_set)),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_2),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPNE, Rojam::Label.new(25 + @all_methods_off_set)),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_3),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, Rojam::Label.new(27 + @all_methods_off_set)),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_4),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_loop loop
      loop.access.should == Rojam::Java::Access::ACC_PUBLIC
      loop.name.should == 'loop'
      loop.desc.should == '()V'
      loop.exceptions.should be_empty
      loop.max_stack.should == 2
      loop.max_locals.should == 2

      loop.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::IntInsn.new(Rojam::Opcode::BIPUSH, 10),
        Rojam::JumpInsn.new(Rojam::Opcode::IF_ICMPGE, Rojam::Label.new(32 + @all_methods_off_set)),
        Rojam::IincInsn.new(Rojam::Opcode::IINC, 1, 1),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, Rojam::Label.new),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_arith arith
      arith.access.should == Rojam::Java::Access::ACC_PUBLIC
      arith.name.should == 'arith'
      arith.desc.should == '()V'
      arith.exceptions.should be_empty
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
      object.exceptions.should be_empty
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

    def compare_arith_for_long arith
      arith.access.should == Rojam::Java::Access::ACC_PUBLIC
      arith.name.should == 'arith_for_long'
      arith.desc.should == '()V'
      arith.exceptions.should be_empty
      arith.max_stack.should == 4
      arith.max_locals.should == 11

      arith.instructions.should == [
        Rojam::LdcInsn.new(Rojam::Opcode::LDC2_W, 5),
        Rojam::VarInsn.new(Rojam::Opcode::LSTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::LLOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::LCONST_1),
        Rojam::Instruction.new(Rojam::Opcode::LADD),
        Rojam::VarInsn.new(Rojam::Opcode::LSTORE, 3),
        Rojam::VarInsn.new(Rojam::Opcode::LLOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::LCONST_1),
        Rojam::Instruction.new(Rojam::Opcode::LSUB),
        Rojam::VarInsn.new(Rojam::Opcode::LSTORE, 5),
        Rojam::VarInsn.new(Rojam::Opcode::LLOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::LCONST_1),
        Rojam::Instruction.new(Rojam::Opcode::LMUL),
        Rojam::VarInsn.new(Rojam::Opcode::LSTORE, 7),
        Rojam::VarInsn.new(Rojam::Opcode::LLOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::LCONST_1),
        Rojam::Instruction.new(Rojam::Opcode::LDIV),
        Rojam::VarInsn.new(Rojam::Opcode::LSTORE, 9),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_return_for_int method
      method.access.should == Rojam::Java::Access::ACC_PUBLIC
      method.name.should == 'return_for_int'
      method.desc.should == '()I'
      method.exceptions.should be_empty
      method.max_stack.should == 1
      method.max_locals.should == 1

      method.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::IRETURN)
      ]
    end

    def compare_return_for_long method
      method.access.should == Rojam::Java::Access::ACC_PUBLIC
      method.name.should == 'return_for_long'
      method.desc.should == '()J'
      method.exceptions.should be_empty
      method.max_stack.should == 2
      method.max_locals.should == 1

      method.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::LCONST_1),
        Rojam::Instruction.new(Rojam::Opcode::LRETURN)
      ]
    end

    def compare_array(method)
      method.access.should == Rojam::Java::Access::ACC_PUBLIC
      method.name.should == 'array'
      method.desc.should == '()V'
      method.exceptions.should be_empty
      method.max_stack.should == 3
      method.max_locals.should == 6

      method.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::IntInsn.new(Rojam::Opcode::NEWARRAY, Rojam::ArrayType::T_INT),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::TypeInsn.new(Rojam::Opcode::ANEWARRAY, 'java/lang/Object'),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 2),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ARRAYLENGTH),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 3),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::Instruction.new(Rojam::Opcode::IASTORE),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 1),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::Instruction.new(Rojam::Opcode::IALOAD),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 4),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 2),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::Instruction.new(Rojam::Opcode::ACONST_NULL),
        Rojam::Instruction.new(Rojam::Opcode::AASTORE),
        Rojam::VarInsn.new(Rojam::Opcode::ALOAD, 2),
        Rojam::Instruction.new(Rojam::Opcode::ICONST_0),
        Rojam::Instruction.new(Rojam::Opcode::AALOAD),
        Rojam::VarInsn.new(Rojam::Opcode::ASTORE, 5),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    def compare_exception method
      method.access.should == Rojam::Java::Access::ACC_PUBLIC
      method.name.should == 'exception'
      method.desc.should == '()V'
      method.exceptions.should have(1).items
      method.exceptions[0].should == 'java/lang/Exception'
      method.max_stack.should == 3
      method.max_locals.should == 1

      method.instructions.should == [
        Rojam::TypeInsn.new(Rojam::Opcode::NEW, 'java/lang/Exception'),
        Rojam::Instruction.new(Rojam::Opcode::DUP),
        Rojam::LdcInsn.new(Rojam::Opcode::LDC, 'exception'),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, 'java/lang/Exception', '<init>', '(Ljava/lang/String;)V'),
        Rojam::Instruction.new(Rojam::Opcode::ATHROW)
      ]
    end

    def compare_switch_case method
      method.access.should == Rojam::Java::Access::ACC_PUBLIC
      method.name.should == 'switch_case'
      method.desc.should == '()V'
      method.exceptions.should be_empty
      method.max_stack.should == 1
      method.max_locals.should == 2

      case_table = {
        1 => Rojam::Label.new(81 + @all_methods_off_set)
      }

      method.instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ICONST_1),
        Rojam::VarInsn.new(Rojam::Opcode::ISTORE, 1),
        Rojam::VarInsn.new(Rojam::Opcode::ILOAD, 1),
        Rojam::LookupSwitchInsn.new(Rojam::Opcode::LOOKUPSWITCH, Rojam::Label.new(85 + @all_methods_off_set), case_table),
        Rojam::JumpInsn.new(Rojam::Opcode::GOTO, Rojam::Label.new(85 + @all_methods_off_set)),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end
    
    it "creates node with methods" do
      @node.methods.should have(15).items
      compare_constructor(@node.methods[0])
      compare_getter(@node.methods[1])
      compare_assignment(@node.methods[2])
      compare_conditional(@node.methods[3])
      compare_loop(@node.methods[4])
      compare_arith(@node.methods[5])
      compare_object(@node.methods[6])
      compare_arith_for_long(@node.methods[7])
      compare_return_for_int(@node.methods[8])
      compare_return_for_long(@node.methods[9])
      compare_array(@node.methods[10])
      compare_exception(@node.methods[11])
      compare_switch_case(@node.methods[12])
      compare_return_for_arraylist(@node.methods[13])
      compare_use_arraylist(@node.methods[14])
    end

    it "creates node with attributes" do
      @node.source_file.should == "CommonClass.java"
    end
  end
end