module Rojam
  module  Opcode
    ICONST_1      = 0x04
    LDC           = 0x12
    ILOAD_1       = 0x1B
    ALOAD_0       = 0x2A
    ISTORE_1      = 0x3C
    ISTORE_2      = 0x3D
    ARETURN       = 0xB0
    RETURN        = 0xB1
    GETSTATIC     = 0xB2
    GETFIELD      = 0xB4
    INVOKEVIRTUAL = 0xB6
    INVOKESPECIAL = 0xB7
  end
end