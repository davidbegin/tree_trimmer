require_relative 'minitest_helper'

class TestTreeTrimmer < Minitest::Test
  def setup

    TreeTrimmer.instance_eval do
      def self.tree_trimmer
        mock = Minitest::Mock.new
        mock.expect(:trim_branches, :trim_branches_called)
      end
    end
  end

  def teardown
    TreeTrimmer.instance_eval do
      def self.tree_trimmer
        Base.new
      end
    end
  end

  def test_lets_clean_up_some_branches_invokes_tree_trimmer
    assert_equal :trim_branches_called, TreeTrimmer.lets_clean_up_some_branches
  end
end
