require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFile do
  describe 'to_node' do
    before(:all) do
      @java_class = Rojam::ClassFile.new
      @class_io = File.new(File.dirname(__FILE__) + "/Blank.class")
      @java_class.read(@class_io)
      @node = @java_class.to_node
    end
    
    after(:all) do
      @class_io.close
    end

    it "creates node with version" do
      @node.version.should == Rojam::Constants::Versions::V1_6
    end
    
    it "creates node with access" do
      @node.access.should == Rojam::Constants::AccessFlags::ACC_SUPER
    end
    
    it "creates node with name" do
      @node.name.should == "Blank"
    end
    
    it "creates node with super name" do
      @node.super_name.should == "java/lang/Object"
    end
    
    it "creates node with interfaces" do
      @node.interfaces.should be_empty
    end
    
    it "creates node with fields" do
      @node.fields.should be_empty
    end
    
    it "creates node with methods" do
      @node.methods.should have(1).items
    end
  end
end