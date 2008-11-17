require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "cp_info" do
  {
    :constant_utf8 => {
      :binary => [0x00, 0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E],
      :proc => lambda {|result| result == "<init>"},
      :object => "<init>"
    },
    
    :constant_integer => {
      :binary => [0x00, 0x00, 0x00, 0x7B],
      :proc => lambda {|result| result.bytes == 0x7B},
      :object => Struct.new(:bytes).new(0x7B)
    },
    
    :constant_float => {
      :binary => [0x42, 0xF6, 0xA4, 0x5A],
      :proc => lambda {|result| result.bytes == 0x42F6A45A},
      :object => Struct.new(:bytes).new(0x42F6A45A)
    },
    
    :constant_long => {
      :binary => [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7B],
      :proc => lambda {|result| 
        result.high_bytes == 0x00 && result.low_bytes == 0x7B
      },
      :object => Struct.new(:high_bytes, :low_bytes).new(0x00, 0x7B)
    },
    
    :constant_double => {
      :binary => [0x40, 0x5E, 0xD4, 0x8B, 0x43, 0x95, 0x81, 0x06],
      :proc => lambda {|result| 
        result.high_bytes == 0x405ED48B && result.low_bytes == 0x43958106
      },
      :object => Struct.new(:high_bytes, :low_bytes).new(0x405ED48B, 0x43958106)
    },
    
    :constant_class => {
      :binary => [0x00, 0x0B],
      :proc => lambda {|result| result.name_index == 0x0B },
      :object => Struct.new(:name_index).new(0x0B)
    },
    
    :constant_string => {
      :binary => [0x00, 0x34],
      :proc => lambda {|result| result.string_index == 0x34 },
      :object => Struct.new(:string_index).new(0x34)
    },
  
    :constant_fieldref => {
      :binary => [0x00, 0x2C, 0x00, 0x2D],
      :proc => lambda {|result| result.class_index == 0x2C && result.name_and_type_index == 0x2D},
      :object => Struct.new(:class_index, :name_and_type_index).new(0x2C, 0x2D)
    },
    
    :constant_methodref => {
      :binary => [0x00, 0x03, 0x00, 0x0A],
      :proc => lambda { |result|
        result.class_index == 0x03 && result.name_and_type_index == 0x0A
      },
      :object => Struct.new(:class_index, :name_and_type_index).new(0x03, 0x0A)
    },
    
    :constant_interfacemethodref => {
      :binary => [0x00, 0x03, 0x00, 0x1F],
      :proc => lambda { |result|
        result.class_index == 0x03 && result.name_and_type_index == 0x1F
      },
      :object => Struct.new(:class_index, :name_and_type_index).new(0x03, 0x1F)
    },
    
    :constant_name_and_type => {
      :binary => [0x00, 0x04, 0x00, 0x05],
      :proc => lambda { |result|
        result.name_index == 0x04 && result.descriptor_index == 0x05
      },
      :object => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05)
    }
  }.each do |klass, options|
    describe klass do
      before(:each) do
        @desc = RBits::Type.create_field(klass)
      end
      
      it "read #{klass}" do
        io = RBits::BytesIO.new(options[:binary])
        options[:proc].call(@desc.read(io)).should be_true
      end
      
      it "write #{klass}" do
        io = RBits::BytesIO.new
        @desc.write(io, options[:object])
        io.bytes.should == options[:binary]
      end
    end
  end
end