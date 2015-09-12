require "tree_trimmer/version"
require "tree_trimmer/base"

module TreeTrimmer
  def self.lets_clean_up_some_branches
    puts "\nBranches to Clean:\n\n"
    Base.new.trim_branches
  end
end
