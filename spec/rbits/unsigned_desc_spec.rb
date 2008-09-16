require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestSubForUnsigned < RBits
  class << self
    def cleaup_fields
      field_descriptors.clear
    end
  end
end

describe UnsignedDesc do
  before(:each) do
    @desc = UnsignedDesc.new(1)
    @io = StringIO.new
  end
  describe 'write' do
    it "writes fields correctly" do
      @desc.write(@io, 1)
      @io.string.should == "\001"
    end

    it 'writes default value if the field is nil' do
      @desc = UnsignedDesc.new(1, :default => 2)
      @desc.write(@io, nil)
      @io.string.should == "\002"
    end
    
    it 'writes zero if the default value is not set' do
      @desc.write(@io, nil)
      @io.string.should == "\000"
    end
    
    it 'write constant if the constant is set' do
      @desc = UnsignedDesc.new(1, :const => 1)
      some_value = 2
      @desc.write(@io, some_value)
      @io.string.should == "\001"
    end
  end
  
  describe 'read' do
    it "reads fields correctly" do
      @io.string = "\001"
      @desc.read(@io).should == 1
    end
    
    it "reads constant" do
      @desc = UnsignedDesc.new(1, :const => 1)
      @io.string = "\001"
      @desc.read(@io).should == 1
    end
    
    it "raises error if constant is not correct" do
      @desc = UnsignedDesc.new(1, :const => 1)
      @io.string = "\002"
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