require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ConstantPoolWriter do
  before(:each) do
    @writer = Rojam::ConstantPoolWriter.new
  end

  it "generates class name" do
    index = @writer.class_name('CommonClass')
    reader = Rojam::ConstantPoolReader.new(@writer.cp_info)
    reader.class_name(index).should == 'CommonClass'
  end
end