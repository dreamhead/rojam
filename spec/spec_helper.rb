require 'rubygems'
require 'simplecov'
require 'rspec'

SimpleCov.start do
  add_filter 'spec'
end

require File.expand_path(File.dirname(__FILE__) + '/../lib/rojam')
