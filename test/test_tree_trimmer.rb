$LOAD_PATH << "test"
require 'minitest_helper'

class FakeStdout
  attr_reader :output

  def initialize
    @output     = []
  end

  def puts(msg)
    output << msg
  end

  def print(msg)
    output << msg
  end
end

class FakeStdin
  def initialize(user_input)
    @user_input = user_input
  end

  def gets
    @user_input.pop
  end
end

module Downup
  class Base
    class << self
      def set_prompt_return(retval)
        @retval = retval
      end

      def new(*)
        @mock = Minitest::Mock.new
        @mock.expect(:prompt, @retval)
      end
    end
  end
end

TreeTrimmer::Base.class_eval do
  def branches
    ["branch-one", "branch-two"]
  end
end

class TestTreeTrimmer < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TreeTrimmer::VERSION
  end

  def test_selecting_an_option
    Downup::Base.set_prompt_return(["branch-one"])
    stdin = FakeStdin.new(["q", "n"])
    subject = TreeTrimmer::Base.new(
      stdin: stdin, stdout: FakeStdout.new
    )

    TreeTrimmer::Base.class_eval do
      def delete_branches!
      end
    end

    subject.trim_branches
  end
end
