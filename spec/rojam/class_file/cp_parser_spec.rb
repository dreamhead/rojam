require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/cp_info_stub')

describe Rojam::CpParser do
  include Rojam::CpParser
  include CpInfoStub
  
  it "parses class name" do
    add_constants({
        1 => Struct.new(:name_index).new(0x02),
        2 => "Blank"
    })
  
    class_name(1).should == "Blank"
  end
  
  it "parses method owner name" do
    add_constants({
        1 => Struct.new(:name_index).new(0x02),
        2 => "Blank",
        3 => Struct.new(:class_index).new(0x01)
    })
  
    method_owner_name(3).should == "Blank"
  end
  
  it "parses name and desc" do
    add_constants({
        1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
        3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
        4 => "<init>",
        5 => "()V",
    })
  
    name_and_desc(1).should == ["<init>", "()V"]
  end
end

