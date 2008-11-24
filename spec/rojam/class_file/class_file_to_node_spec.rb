require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFile do
  describe 'to_node' do
    before(:all) do
      @java_class = Rojam::ClassFile.new
      @class_io = File.new(File.dirname(__FILE__) + "/fixtures/CommonClass.class", "rb")
      @java_class.read(@class_io)
      @node = @java_class.to_node
    end
    
    after(:all) do
      @class_io.close
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
      @node.methods.should have(1).items
      @node.methods[0].access.should == Rojam::Java::Access::ACC_PUBLIC
      @node.methods[0].name.should == "<init>"
      @node.methods[0].desc.should == "()V"
      @node.methods[0].max_stack.should == 1
      @node.methods[0].max_locals.should == 1
      @node.methods[0].line_number.should == 0x01
      @node.methods[0].instructions.should == [
        Rojam::Instruction.new(Rojam::Opcode::ALOAD_0),
        Rojam::MethodInsn.new(Rojam::Opcode::INVOKESPECIAL, "java/lang/Object", "<init>", "()V"),
        Rojam::Instruction.new(Rojam::Opcode::RETURN)
      ]
    end

    it "creates node with attributes" do
      @node.source_file.should == "CommonClass.java"
    end
  end
end