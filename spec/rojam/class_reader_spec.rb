require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rojam::ClassReader do
  before(:each) do
    @class_reader = Rojam::ClassReader.new
  end

  it "reads class node from io" do
    File.open(File.dirname(__FILE__) + '/class_file/Blank.class') do |f|
      node = @class_reader.read(f)
      node.version.should == Rojam::Constants::Versions::V1_6
    end
  end
end

