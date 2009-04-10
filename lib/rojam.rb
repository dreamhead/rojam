$:.unshift(File.dirname(__FILE__))

require 'rbits'

require 'rojam/object_model/opcode'
require 'rojam/object_model/instruction'
require 'rojam/object_model/constants'
require 'rojam/object_model/class_node'
require 'rojam/object_model/member_node'
require 'rojam/object_model/method_node'
require 'rojam/object_model/field_node'
require 'rojam/object_model/label'

require 'rojam/class_file/cp_info'
require 'rojam/class_file/class_info'
require 'rojam/class_file/instruction_parser'
require 'rojam/class_file/attribute_info'
require 'rojam/class_file/attribute_parser'
require 'rojam/class_file/class_node_parser'
require 'rojam/class_file/class_file_generator'
require 'rojam/class_file/class_file'
require 'rojam/class_file/constant_pool'
require 'rojam/class_file/label_manager'

require 'rojam/class_builder/class_builder'
require 'rojam/class_reader'