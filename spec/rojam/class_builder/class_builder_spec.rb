require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassBuilder do
  before(:all) do
    @class_builder = Rojam::ClassBuilder.build("JavaClass", "java.lang.Object") do
      constructor do
      end
    end
    @class_node = @class_builder.to_node
  end
  
  it "creates class node with name" do
    @class_node.name.should == "JavaClass"
    @class_node.super_name.should == "java/lang/Object"
  end
  
  it "creates class node with default super name" do
    @class_builder = Rojam::ClassBuilder.build("JavaClass")
    @class_node = @class_builder.to_node
    @class_node.super_name.should == "java/lang/Object"
  end
  
  it "creates class node with interfaces" do
    @class_node.interfaces.should be_empty
  end
  
  it "creates class node with fields" do
    @class_node.fields.should be_empty
  end
  
  it "creates class node with methods" do
    @class_node.methods.should have(1).items
    @class_node.methods[0].name.should == "<init>"
    @class_node.methods[0].desc.should == "()V"
  end
end