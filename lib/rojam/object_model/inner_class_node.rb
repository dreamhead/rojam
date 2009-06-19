module Rojam
  class InnerClassNode
    attr_accessor :name, :outer_name, :inner_name, :access
    
    def initialize(name, outer_name, inner_name, access)
      @name = name
      @outer_name = outer_name
      @inner_name = inner_name
      @access = access
      yield self if block_given?
    end
  end
end