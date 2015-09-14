require_relative 'minitest_helper'

module TreeTrimmer
  class Base
    def trim_branches
      :trim_branches_called
    end
  end
end

class TestTreeTrimmer < Minitest::Test
  def test_lets_clean_up_some_branches_invokes_tree_trimmer
    assert_equal :trim_branches_called, TreeTrimmer.lets_clean_up_some_branches
  end
end
