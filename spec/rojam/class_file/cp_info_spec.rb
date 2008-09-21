require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "cp_info" do
  {
    Rojam::CONSTANT_Utf8 => {
      :binary => "\x00\x06\x3C\x69\x6E\x69\x74\x3E",
      :proc => lambda {|result| result == "<init>"},
      :object => "<init>"
    },
    
    Rojam::CONSTANT_Class => {
      :binary => "\x00\x0B",
      :proc => lambda {|result| result.name_index == 0x0B },
      :object => Struct.new(:name_index).new(0x0B)
    },
    
    Rojam::CONSTANT_Methodref => {
      :binary => "\x00\x03\x00\x0A",
      :proc => lambda { |result|
        result.class_index == 0x03 && result.name_and_type_index == 0x0A
      },
      :object => Struct.new(:class_index, :name_and_type_index).new(0x03, 0x0A)
    },
    
    Rojam::CONSTANT_InterfaceMethodref => {
      :binary => "\x01\x03\x00\x0A",
      :proc => lambda { |result|
        result.class_index == 0x0103 && result.name_and_type_index == 0x0A
      },
      :object => Struct.new(:class_index, :name_and_type_index).new(0x0103, 0x0A)
    },
    
    Rojam::CONSTANT_NameAndType => {
      :binary => "\x00\x04\x00\x05",
      :proc => lambda { |result|
        result.name_index == 0x04 && result.descriptor_index == 0x05
      },
      :object => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05)
    }
  }.each do |klass, options|
    describe klass do
      it "read #{klass}" do
        desc = klass.new
        io = StringIO.new(options[:binary])
        options[:proc].call(desc.read(io)).should be_true
      end
      
      it "write #{klass}" do
        desc = klass.new
        io = StringIO.new
        desc.write(io, options[:object])
        io.string.should == options[:binary]
      end
    end
  end
end