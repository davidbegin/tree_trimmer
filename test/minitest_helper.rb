require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tree_trimmer'
require_relative "fake_io"
require_relative "fake_downup"
require 'minitest/mock'
require 'minitest/autorun'
