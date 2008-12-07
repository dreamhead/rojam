module Rojam
  class Instruction
    attr_accessor :opcode
  
    def initialize(opcode)
      @opcode = opcode
    end
    
    def ==(insn)
      (self.class == insn.class) && (@opcode == insn.opcode)
    end
  end

  {
    :Method => [:owner, :name, :desc],
    :Field  => [:owner, :name, :desc],
    :Var    => [:var],
    :Type   => [:type],
    :Int    => [:operand],
    :Iinc   => [:var, :incr],
    :Jump   => [:label],
    :Ldc    => [:constant],
  }.each do |type, args|
    module_eval <<-INSTRUCTION
    class #{type}Insn < Instruction
      attr_accessor #{args.collect{|item| ":#{item}"}.join(',')}

      def initialize(opcode, #{args.collect{|item| "#{item}"}.join(',')})
        super(opcode)
        #{args.collect{|item| "@#{item} = #{item}"}.join("\n")}
      end

      def ==(insn)
        super(insn) && #{args.collect{|item| "@#{item} == insn.#{item}"}.join('&&')}
      end
    end
    INSTRUCTION
  end
end