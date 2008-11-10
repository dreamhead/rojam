  module Rojam
  class ClassNode
    attr_accessor :version, :access, :source_file, :name, :super_name
    attr_reader :interfaces, :fields, :methods
    
    def initialize
      @interfaces = []
      @fields = []
      @methods = []
      yield self if block_given?
    end
  end
end