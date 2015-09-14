require "tree_trimmer/version"
require "tree_trimmer/base"

module TreeTrimmer
  class << self
    def lets_clean_up_some_branches
      puts "\nBranches to Clean:\n\n"
      tree_trimmer.trim_branches
    end

    private

    def tree_trimmer
      Base.new
    end
  end
end
