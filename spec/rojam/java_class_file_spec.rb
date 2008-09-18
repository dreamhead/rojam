require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClassFile do
  before(:each) do
    @java_class = ClassFile.new
    @class_io = StringIO.new("\xCA\xFE\xBA\xBE\x00\x00\x00\x32\x00\x06\x0A\x00\x03\x00\x0A\x07\x00\x0B\x07\x00\x0C\x01\x00\x06\x3C\x69\x6E\x69\x74\x3E\x01\x00\x03\x28\x29\x56")
    @java_class.read(@class_io)    
  end

  it 'reads magic number' do
    @java_class.magic.should == 0xCAFEBABE
  end
  
  it 'reads version' do
    @java_class.minor_version.should == 0x00
    @java_class.major_version.should == 0x32
  end
  
  it 'reads constant pool' do
    @java_class.cp_info.size.should == 5
    @java_class.cp_info[0].info.class_index.should == 0x03
    @java_class.cp_info[0].info.name_and_type_index.should == 0x0A
    @java_class.cp_info[1].info.name_index.should == 0x0B
    @java_class.cp_info[2].info.name_index.should == 0x0C
    @java_class.cp_info[3].info.should == "<init>"
    @java_class.cp_info[4].info.should == "()V"
  end
end

