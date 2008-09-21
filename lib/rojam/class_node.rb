module Rojam
  class ClassNode
    attr_accessor :version, :access, :source_file,
      :name, :super_name, :interfaces,
      :fields, :methods
    
    def initialize
      yield self if block_given?
    end
  end
end
