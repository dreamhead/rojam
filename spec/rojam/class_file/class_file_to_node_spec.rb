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
      @node.interfaces.should be_empty
    end
    
    it "creates node with fields" do
      @node.fields.should have(2).items
      constant_field = @node.fields[0]
      constant_field.access.should ==
        Rojam::Java::Access::ACC_PRIVATE | Rojam::Java::Access::ACC_STATIC | Rojam::Java::Access::ACC_FINAL
      constant_field.name.should == 'CONSTANT'
      constant_field.desc.should == 'Ljava/lang/String;'
      constant_field.signature.should be_nil
      constant_field.value.should == 'constant'

      instance_field = @node.fields[1]
      instance_field.access.should == Rojam::Java::Access::ACC_PRIVATE
      instance_field.name.should == 'text'
      instance_field.desc.should == 'Ljava/lang/String;'
      instance_field.signature.should be_nil
      instance_field.value.should be_nil
    end
    
    it "creates node with methods" do
      @node.methods.should have(2).items
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
    end

    it "creates node with attributes" do
      @node.source_file.should == "CommonClass.java"
    end
  end
end