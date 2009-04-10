require 'rubygems'

SPEC = Gem::Specification.new do |s|
        s.name          = 'rojam'
        s.version       = '0.1'
        s.author        = 'Ye Zheng'
        s.email         = 'dreamhead.cn@gmail.com'
        s.homepage      = 'http://dreamhead.blogbus.com'
        s.platform      = Gem::Platform::RUBY
        s.summary       = 'Rojam is a Java bytecode manipulation framework in Ruby.'
        s.files         = Dir.glob("{lib, spec}/**/*")
        s.require_path  = 'lib'
	s.add_dependency("rojam", ">= 0.1.0")
end
