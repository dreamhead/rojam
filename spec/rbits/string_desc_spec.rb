require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SubStringDesc < RBits::String
  size :type => :u2
end

describe RBits::String do
  describe "read" do
    it "read string correctly" do
      @io = StringIO.new("\x06\x3C\x69\x6E\x69\x74\x3E")
      @desc = RBits::String.new
      
      @desc.read(@io).should == "<init>"
    end
  end
  
  describe "write" do
    it "write string correctly" do
      @io = StringIO.new
      @desc = RBits::String.new
      
      target = "<init>"
      @desc.write(@io, target)
      @io.string.should == "\x06\x3C\x69\x6E\x69\x74\x3E"
    end
  end
  
  describe "options" do
    it "read string correctly" do
      @io = StringIO.new("\x00\x06\x3C\x69\x6E\x69\x74\x3E")
      @desc = SubStringDesc.new
      
      @desc.read(@io).should == "<init>"
    end
    
    it "write string correctly" do
      @io = StringIO.new
      @desc = SubStringDesc.new

      target = "<init>"
      @desc.write(@io, target)
      @io.string.should == "\x00\x06\x3C\x69\x6E\x69\x74\x3E"
    end
  end
end