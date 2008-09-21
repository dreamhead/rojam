module Rojam
  class MethodNode
    attr_accessor :access, :name, :desc
    
    def initialize
      yield self if block_given?
    end
  end
end
