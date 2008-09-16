require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ClassFile do
  before(:each) do
    @java_class = ClassFile.new
    @class_io = StringIO.new("\xCA\xFE\xBA\xBE\x00\x00\x00\x32\x00\x02\x0A\x00\x03\x00\x0A")
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
    @java_class.cp_info.size.should == 1
    @java_class.cp_info[0].info.class_index.should == 0x03
    @java_class.cp_info[0].info.name_and_type_index.should == 0x0A
  end
end

