require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SwitchBits
  attr_accessor :switch_tag
  attr_accessor :switch_value
end

class SubSwitchDesc < SwitchDesc
  tag :switch_tag, :type => :u1
  value :switch_value, :types => {1 => :u1, 2 => :u2}
end

describe SwitchDesc do
  describe "class options" do
    before(:each) do
      @desc = SubSwitchDesc.new
      @io = StringIO.new
      @bits = SwitchBits.new
    end
    
    describe "write" do
      it "writes switch field for ref 1 correctly" do
        @bits.switch_tag = 1
        @bits.switch_value = 1
        @desc.write @io, @bits
        @io.string.should == "\x01\x01"
      end
    
      it "writes switch field for ref 2 correctly" do
        @bits.switch_tag = 2
        @bits.switch_value = 2
        @desc.write @io, @bits
        @io.string.should == "\x02\x00\x02"
      end
    
      it "raises error without ref value" do
        @bits.switch_tag = -1
        @bits.switch_value = -1
        lambda { @desc.write(@io, @bits) }.should raise_error
      end
    end
    
    describe "read" do
      it "reads switch field for ref 1 correctly" do
        @io.string = "\x01\x01"
        bits = @desc.read(@io)
        bits.switch_tag.should == 1
        bits.switch_value.should == 1
      end
    
      it "reads switch field for ref 2 correctly" do
        @io.string = "\x02\x00\x02"
      
        bits = @desc.read(@io)
        bits.switch_tag.should == 2
        bits.switch_value.should == 2
      end
    
      it "raises error without ref value" do
        @io.string = "\x03"
        lambda { @desc.read(@io) }.should raise_error
      end
    end
  end
end