module Rojam
  class FieldNode
    include MemberNode
    
    attr_accessor :access, :name, :desc, :signature, :value

    def initialize
      yield self if block_given?
    end
  end
end
