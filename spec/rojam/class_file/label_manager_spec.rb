require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::LabelManager do
  before(:each) do
    @labels = Rojam::LabelManager.new
  end

  it 'gets label from label manager without initialization' do
    @labels[0].should_not be_nil
  end

  it 'regets the same label' do
    @labels[0].should == @labels[0]
  end

  it 'increases size after access' do
    @labels.should have(0).items
    label = @labels[0]
    @labels.should have(1).items
  end

  it 'sets line for label' do
    label = @labels[0]
    label.line = 5
    @labels[0].line.should == 5
  end
end

