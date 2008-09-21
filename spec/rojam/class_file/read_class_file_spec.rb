require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rojam::ClassFile do
  describe 'read' do
    before(:all) do
      @java_class = Rojam::ClassFile.new
      @class_io = File.new(File.dirname(__FILE__) + "/Blank.class")
      @java_class.read(@class_io)
    end
    
    after(:all) do
      @class_io.close
    end

    it 'reads magic number' do
      @java_class.magic.should == 0xCAFEBABE
    end
  
    it 'reads version' do
      @java_class.minor_version.should == 0x00
      @java_class.major_version.should == 0x32
    end
  
    it 'reads constant pool' do
      @java_class.cp_info.should have(12).items
      @java_class.cp_info[0].info.class_index.should == 0x03
      @java_class.cp_info[0].info.name_and_type_index.should == 0x0A
      @java_class.cp_info[1].info.name_index.should == 0x0B
      @java_class.cp_info[2].info.name_index.should == 0x0C
      @java_class.cp_info[3].info.should == "<init>"
      @java_class.cp_info[4].info.should == "()V"
      @java_class.cp_info[5].info.should == "Code"
      @java_class.cp_info[6].info.should == "LineNumberTable"
      @java_class.cp_info[7].info.should == "SourceFile"
      @java_class.cp_info[8].info.should == "Blank.java"
      @java_class.cp_info[9].info.name_index.should == 0x04
      @java_class.cp_info[9].info.descriptor_index.should == 0x05
      @java_class.cp_info[10].info.should == "Blank"
      @java_class.cp_info[11].info.should == "java/lang/Object"
    end
  
    it 'reads access flag' do
      @java_class.access_flags.should == 0x20
    end
  
    it 'reads this class' do
      @java_class.this_class.should == 0x02
    end
  
    it 'reads super class' do
      @java_class.super_class.should == 0x03
    end
    
    it 'reads interfaces' do
      @java_class.interfaces.size.should == 0x00
    end
    
    it 'reads fields' do
      @java_class.fields.size.should == 0x00
    end

    it 'reads methods' do
      @java_class.methods.should have(1).items
      @java_class.methods[0].access_flags.should == 0x00
      @java_class.methods[0].name_index.should == 0x04
      @java_class.methods[0].descriptor_index.should == 0x05
      @java_class.methods[0].attributes.should have(1).items
      @java_class.methods[0].attributes[0].attribute_name_index.should == 0x06
      @java_class.methods[0].attributes[0].infoes.size.should == 0x1d
      @java_class.methods[0].attributes[0].infoes.should == [
        0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x05, 
        0x2A, 0xB7, 0x00, 0x01, 0xb1, 0x00, 0x00, 0x00,
        0x01, 0x00, 0x07, 0x00, 0x00, 0x00, 0x06, 0x00,
        0x01, 0x00, 0x00, 0x00, 0x01
      ]
    end
    
    it 'reads attributes' do
      @java_class.attributes.should have(1).items
      @java_class.attributes[0].attribute_name_index.should == 0x08
      @java_class.attributes[0].infoes.should have(2).items
      @java_class.attributes[0].infoes.should == [0x00, 0x09]
    end
  end
end