require "tree_trimmer/version"
require "pry"

module TreeTrimmer
  def self.lets_clean_up_some_branches
    puts "\nBranches to Clean:\n\n"
    branches = IO.popen("git branch").each_line.map(&:chomp).map(&:lstrip)
    puts branches
  end
end

TreeTrimmer.lets_clean_up_some_branches
