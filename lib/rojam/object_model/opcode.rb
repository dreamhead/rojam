module Rojam
  module  Opcode
    ICONST_0      = 0x03
    ICONST_1      = 0x04
    ICONST_2      = 0x05
    ICONST_3      = 0x06
    ICONST_4      = 0x07
    BIPUSH        = 0x10
    LDC           = 0x12
    ILOAD_1       = 0x1B
    ALOAD_0       = 0x2A
    ISTORE_1      = 0x3C
    ISTORE_2      = 0x3D
    IADD          = 0x60
    IINC          = 0x84
    IF_ICMPNE     = 0xA0
    IF_ICMPGE     = 0xA2
    GOTO          = 0xA7
    ARETURN       = 0xB0
    RETURN        = 0xB1
    GETSTATIC     = 0xB2
    GETFIELD      = 0xB4
    INVOKEVIRTUAL = 0xB6
    INVOKESPECIAL = 0xB7
  end
end