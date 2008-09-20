require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SubFieldDesc < RBits::TypeDescriptor
  field_type :sub
  
  attr_reader :options
  
  def initialize(options)
    @options = options
  end
end

describe RBits::TypeDescriptor do
  it "has sub field type" do
    RBits::TypeDescriptor.should have_field_type(:sub)
  end
  
  it "creates sub field type object" do
    options = {:option => 1}
    field = RBits::TypeDescriptor.create_field(:sub, options)
    field.should be_is_a(SubFieldDesc)
    field.options.should == options
  end
  
  it "raise error if there is no field type" do
    lambda { RBits::TypeDescriptor.create_field(:unknown)}.should raise_error
  end
end

