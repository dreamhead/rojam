require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SubRBits < RBits::Base
  u1 :first
  u1 :second
  u1 :third
end

describe RBits::Base do
  before(:each) do
    @bits = SubRBits.new
    @io = StringIO.new
  end
    
  it 'adds getter and setter' do
    @bits.first = 1
    @bits.first.should == 1
  end
  
  describe 'read/write object' do
    it 'write object sequently' do
      @bits.first = 1
      @bits.second = 2
      @bits.third = 6
      @bits.write(@io)
      @io.string.should == "\001\002\006"
    end
    
    it 'read object sequently' do
      @io.string = "\001\002\006"
      @bits.read(@io)
      @bits.first.should == 1
      @bits.second.should == 2
      @bits.third.should == 6
    end
  end
end

