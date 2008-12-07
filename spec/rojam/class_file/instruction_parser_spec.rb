require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/constant_pool_reader_stub')

describe Rojam::InstructionParser do
  before(:each) do
    @pool = ConstantPoolReaderStub.new
    @labels = Rojam::LabelManager.new
    @parser = Rojam::InstructionParser.new @pool, @labels
  end
  
  it "parses instruction sequentially" do
    node = Rojam::MethodNode.new
    @parser.parse(node, [Rojam::Opcode::NOP, Rojam::Opcode::NOP])
    node.instructions.should have(2).items
    node.instructions[0].opcode.should == Rojam::Opcode::NOP
    node.instructions[1].opcode.should == Rojam::Opcode::NOP
  end

  it 'parses no arg instruction' do
    [Rojam::Opcode::NOP,
      Rojam::Opcode::ACONST_NULL, Rojam::Opcode::ICONST_M1,
      Rojam::Opcode::ICONST_0, Rojam::Opcode::ICONST_1,
      Rojam::Opcode::ICONST_2, Rojam::Opcode::ICONST_3,
      Rojam::Opcode::ICONST_4, Rojam::Opcode::ICONST_5,
      Rojam::Opcode::LCONST_0, Rojam::Opcode::LCONST_1,
      Rojam::Opcode::IALOAD, Rojam::Opcode::IASTORE,
      Rojam::Opcode::AALOAD, Rojam::Opcode::AASTORE,
      Rojam::Opcode::IADD, Rojam::Opcode::ISUB,
      Rojam::Opcode::IMUL, Rojam::Opcode::IDIV,
      Rojam::Opcode::LADD, Rojam::Opcode::LSUB,
      Rojam::Opcode::LMUL, Rojam::Opcode::LDIV,
      Rojam::Opcode::DUP,
      Rojam::Opcode::RETURN, Rojam::Opcode::IRETURN, Rojam::Opcode::LRETURN, Rojam::Opcode::ARETURN,
      Rojam::Opcode::ARRAYLENGTH,
      Rojam::Opcode::ATHROW
    ].each do |opcode|
      instruction = @parser.parse_instruction([opcode])
      instruction.opcode.should == opcode
    end
  end

  it 'parses INVOKESPECIAL' do
    @pool.constants({
        1 => Struct.new(:class_index, :name_and_type_index).new(0x06, 0x03),
        2 => "java/lang/Object",
        3 => Struct.new(:name_index, :descriptor_index).new(0x04, 0x05),
        4 => "<init>",
        5 => "()V",
        6 => Struct.new(:name_index).new(0x02)
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::INVOKESPECIAL, 0x00, 0x01])
    instruction.opcode.should == Rojam::Opcode::INVOKESPECIAL
    instruction.owner.should == "java/lang/Object"
    instruction.name.should == "<init>"
    instruction.desc.should == "()V"
  end

  it 'parses INVOKEVIRTUAL' do
    @pool.constants({
        4 => Struct.new(:class_index, :name_and_type_index).new(0x13, 0x14),
        0x13 => Struct.new(:name_index).new(0x1A),
        0x14 => Struct.new(:name_index, :descriptor_index).new(0x1B, 0x1C),
        0x1A => 'java/io/PrintStream',
        0x1B => 'println',
        0x1C => '(Ljava/lang/String;)V'
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::INVOKEVIRTUAL, 0x00, 0x04])
    instruction.opcode.should == Rojam::Opcode::INVOKEVIRTUAL
    instruction.owner.should == 'java/io/PrintStream'
    instruction.name.should == 'println'
    instruction.desc.should == '(Ljava/lang/String;)V'
  end

  it 'parses LDC' do
    @pool.constants({
        3 => Struct.new(:string_index).new(0x12),
        0x12 => 'Hello, World!'
      })
    instruction = @parser.parse_instruction([Rojam::Opcode::LDC, 0x03])
    instruction.opcode.should == Rojam::Opcode::LDC
    instruction.constant.should == 'Hello, World!'
  end

  it 'parses LDC_W' do
    @pool.constants({
        3 => Struct.new(:string_index).new(0x12),
        0x12 => 'Hello, World!'
      })
    instruction = @parser.parse_instruction([Rojam::Opcode::LDC_W, 0x00, 0x03])
    instruction.opcode.should == Rojam::Opcode::LDC_W
    instruction.constant.should == 'Hello, World!'
  end

  it 'parses LDC2_W' do
   @pool.infoes({
       0x04 => Struct.new(:tag, :info).new(Rojam::CONSTANT_LONG_TAG, Struct.new(:high_bytes, :low_bytes).new(0x00, 0x05))
     })
    instruction = @parser.parse_instruction([Rojam::Opcode::LDC2_W, 0x00, 0x04])
    instruction.opcode.should == Rojam::Opcode::LDC2_W
    instruction.constant.should == 5
  end

  it 'parses GETFIELD' do
    @pool.constants({
        4 => Struct.new(:class_index, :name_and_type_index).new(0x13, 0x14),
        0x13 => Struct.new(:name_index).new(0x1A),
        0x14 => Struct.new(:name_index, :descriptor_index).new(0x1B, 0x1C),
        0x1A => 'CommonClass',
        0x1B => 'text',
        0x1C => 'Ljava/lang/String;'
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::GETFIELD, 0x00, 0x04])
    instruction.opcode.should == Rojam::Opcode::GETFIELD
    instruction.owner.should == 'CommonClass'
    instruction.name.should == 'text'
    instruction.desc.should == 'Ljava/lang/String;'
  end

  it 'parses GETSTATIC' do
    @pool.constants({
        4 => Struct.new(:class_index, :name_and_type_index).new(0x13, 0x14),
        0x13 => Struct.new(:name_index).new(0x1A),
        0x14 => Struct.new(:name_index, :descriptor_index).new(0x1B, 0x1C),
        0x1A => 'java/lang/System',
        0x1B => 'out',
        0x1C => 'Ljava/io/PrintStream;'
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::GETSTATIC, 0x00, 0x04])
    instruction.opcode.should == Rojam::Opcode::GETSTATIC
    instruction.owner.should == 'java/lang/System'
    instruction.name.should == 'out'
    instruction.desc.should == 'Ljava/io/PrintStream;'
  end

  it 'parses IF_ICMPNE' do
    @labels[7].line = 19
    instruction = @parser.parse_instruction([Rojam::Opcode::IF_ICMPNE, 0x00, 0x03], 4)
    instruction.opcode.should == Rojam::Opcode::IF_ICMPNE
    instruction.label.should_not be_nil
    instruction.label.line.should == 19
  end

  it 'parses IF_ICMPGE' do
    @labels[7].line = 19
    instruction = @parser.parse_instruction([Rojam::Opcode::IF_ICMPGE, 0x00, 0x03], 4)
    instruction.opcode.should == Rojam::Opcode::IF_ICMPGE
    instruction.label.should_not be_nil
    instruction.label.line.should == 19
  end

  it 'parses GOTO' do
    @labels[14].line = 22
    instruction = @parser.parse_instruction([Rojam::Opcode::GOTO, 0x00, 0x05], 9)
    instruction.opcode.should == Rojam::Opcode::GOTO
    instruction.label.should_not be_nil
    instruction.label.line.should == 22
  end

  it 'parses BIPUSH' do
    instruction = @parser.parse_instruction([Rojam::Opcode::BIPUSH, 0x0A])
    instruction.opcode.should == Rojam::Opcode::BIPUSH
    instruction.operand.should == 0x0A
  end

  it 'parses IINC' do
    instruction = @parser.parse_instruction([Rojam::Opcode::IINC, 0x01, 0x01])
    instruction.opcode.should == Rojam::Opcode::IINC
    instruction.var.should == 0x01
    instruction.incr.should == 0x01
  end

  it 'parses ISTORE' do
    instruction = @parser.parse_instruction([Rojam::Opcode::ISTORE, 0x04])
    instruction.opcode.should == Rojam::Opcode::ISTORE
    instruction.var.should == 0x04
  end

  it 'parses implicit ISTORE' do
    [Rojam::Opcode::ISTORE_0, Rojam::Opcode::ISTORE_1,
      Rojam::Opcode::ISTORE_2, Rojam::Opcode::ISTORE_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::ISTORE
    instruction.var.should == index
    end
  end

  it 'parses LSTORE' do
    instruction = @parser.parse_instruction([Rojam::Opcode::LSTORE, 0x04])
    instruction.opcode.should == Rojam::Opcode::LSTORE
    instruction.var.should == 0x04
  end

  it 'parses implicit LSTORE' do
    [Rojam::Opcode::LSTORE_0, Rojam::Opcode::LSTORE_1,
      Rojam::Opcode::LSTORE_2, Rojam::Opcode::LSTORE_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::LSTORE
    instruction.var.should == index
    end
  end

  it 'parses ASTORE' do
    instruction = @parser.parse_instruction([Rojam::Opcode::ASTORE, 0x04])
    instruction.opcode.should == Rojam::Opcode::ASTORE
    instruction.var.should == 0x04
  end

  it 'parses implicit ASTORE' do
    [Rojam::Opcode::ASTORE_0, Rojam::Opcode::ASTORE_1,
      Rojam::Opcode::ASTORE_2, Rojam::Opcode::ASTORE_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::ASTORE
    instruction.var.should == index
    end
  end

  it 'parses ILOAD' do
    instruction = @parser.parse_instruction([Rojam::Opcode::ILOAD, 0x04])
    instruction.opcode.should == Rojam::Opcode::ILOAD
    instruction.var.should == 0x04
  end

  it 'parses implicit ILOAD' do
    [Rojam::Opcode::ILOAD_0, Rojam::Opcode::ILOAD_1,
      Rojam::Opcode::ILOAD_2, Rojam::Opcode::ILOAD_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::ILOAD
    instruction.var.should == index
    end
  end

  it 'parses LLOAD' do
    instruction = @parser.parse_instruction([Rojam::Opcode::LLOAD, 0x04])
    instruction.opcode.should == Rojam::Opcode::LLOAD
    instruction.var.should == 0x04
  end

  it 'parses implicit LLOAD' do
    [Rojam::Opcode::LLOAD_0, Rojam::Opcode::LLOAD_1,
      Rojam::Opcode::LLOAD_2, Rojam::Opcode::LLOAD_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::LLOAD
    instruction.var.should == index
    end
  end

  it 'parses ALOAD' do
    instruction = @parser.parse_instruction([Rojam::Opcode::ALOAD, 0x04])
    instruction.opcode.should == Rojam::Opcode::ALOAD
    instruction.var.should == 0x04
  end

  it 'parses implicit LLOAD' do
    [Rojam::Opcode::ALOAD_0, Rojam::Opcode::ALOAD_1,
      Rojam::Opcode::ALOAD_2, Rojam::Opcode::ALOAD_3].each_with_index do |opcode, index|
      instruction = @parser.parse_instruction([opcode])
    instruction.opcode.should == Rojam::Opcode::ALOAD
    instruction.var.should == index
    end
  end

  it 'parses NEW' do
    @pool.constants({
        0x04 => Struct.new(:name_index).new(0x13),
        0x13 => 'java/lang/String',
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::NEW, 0x00, 0x04])
    instruction.opcode.should == Rojam::Opcode::NEW
    instruction.type.should == 'java/lang/String'
  end

  it 'parses NEWARRAY' do
    instruction = @parser.parse_instruction([Rojam::Opcode::NEWARRAY, Rojam::ArrayType::T_INT])
    instruction.opcode.should == Rojam::Opcode::NEWARRAY
    instruction.operand.should == Rojam::ArrayType::T_INT
  end

  it 'parses ANEWARRAY' do
    @pool.constants({
        0x05 => Struct.new(:name_index).new(0x13),
        0x13 => 'java/lang/Object',
      })

    instruction = @parser.parse_instruction([Rojam::Opcode::ANEWARRAY, 0x00, 0x05])
    instruction.opcode.should == Rojam::Opcode::ANEWARRAY
    instruction.type.should == 'java/lang/Object'
  end

  it 'parses LOOKUPSWITCH' do
    @labels[20].line = 38
    @labels[23].line = 51
    
    instruction, bytes_size = @parser.parse_instruction([Rojam::Opcode::LOOKUPSWITCH, 0, 0, 0, 20, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 17], 3)
    instruction.opcode.should == Rojam::Opcode::LOOKUPSWITCH
    bytes_size.should == 17
    instruction.default_label.line.should == 51
    instruction.case_table.should have(1).item
    instruction.case_table[1].line.should == 38
  end
end