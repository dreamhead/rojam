module Rojam
  class ClassNode
    attr_accessor :version, :access, 
      :source_file, :source_debug,
      :name, :super_name, :signature, 
      :outer_class, :outer_method, :outer_method_desc
      
    attr_reader :interfaces, :fields, :methods, :inner_classes
    
    def initialize
      @interfaces = []
      @fields = []
      @methods = []
      @inner_classes = []
      yield self if block_given?
    end
  end
end