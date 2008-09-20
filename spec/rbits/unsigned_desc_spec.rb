require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestSubForUnsigned < RBits::Base
  class << self
    def cleaup_fields
      field_descriptors.clear
    end
  end
end

describe RBits::Unsigned do
  before(:each) do
    @desc = RBits::Unsigned.new(1)
    @io = StringIO.new
  end
  describe 'write' do
    it "writes fields correctly" do
      @desc.write(@io, 1)
      @io.string.should == "\x01"
    end

    it 'writes default value if the field is nil' do
      @desc = RBits::Unsigned.new(1, :default => 2)
      @desc.write(@io, nil)
      @io.string.should == "\x02"
    end
    
    it 'writes zero if the default value is not set' do
      @desc.write(@io, nil)
      @io.string.should == "\x00"
    end
    
    it 'write constant if the constant is set' do
      @desc = RBits::Unsigned.new(1, :const => 1)
      some_value = 2
      @desc.write(@io, some_value)
      @io.string.should == "\x01"
    end
  end
  
  describe 'read' do
    it "reads fields correctly" do
      @io.string = "\001"
      @desc.read(@io).should == 1
    end
    
    it "reads constant" do
      @desc = RBits::Unsigned.new(1, :const => 1)
      @io.string = "\x01"
      @desc.read(@io).should == 1
    end
    
    it "raises error if constant is not correct" do
      @desc = RBits::Unsigned.new(1, :const => 1)
      @io.string = "\x02"
      lambda { @desc.read(@io) }.should raise_error
    end
    
    it 'raises error if can not read from io' do
      lambda { @desc.read(@io) }.should raise_error
    end
  end
  
  describe 'field' do
    after(:each) do
      TestSubForUnsigned.cleaup_fields
    end
    
    [1, 2, 4, 8].each do |size|
      it "generates u#{size}" do
        TestSubForUnsigned.send("u#{size}", :field)
        u = TestSubForUnsigned.new
        u.field = 1
        u.field.should == 1
      end
    end
  end
end