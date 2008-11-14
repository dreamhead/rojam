module Rojam
  class FieldNode
    include MemberNode
    
    attr_accessor :access, :name, :desc, :signature, :value
  end
end
