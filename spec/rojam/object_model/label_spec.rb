require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::Label do
  it "should desc" do
    first_label = Rojam::Label.new
    first_label.line = 1
    second_label = Rojam::Label.new
    second_label.line = 1
    first_label.should == first_label
    second_label.should == first_label

    another_label = Rojam::Label.new
    another_label.line = 2
    another_label.should_not == first_label
  end
end

