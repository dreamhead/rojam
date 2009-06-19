module Rojam
  class MethodNode
    include MemberNode
    
    attr_accessor :access, :name, :desc, :signature, :annotationDefault, 
      :max_stack, :max_locals, :deprecated, 
      :start_pc, :line_number # TODO: REMOVED
    
    attr_reader :exceptions, 
      :visible_parameter_annotations, :invisible_parameter_annotations,
      :instructions, :try_catch_blocks, :local_variables
    
    def initialize
      @exceptions = []
      @visible_parameter_annotations = []
      @invisible_parameter_annotations = []
      @instructions = []
      @try_catch_blocks = []
      @local_variables = []
      
      yield self if block_given?
    end
  end
end
