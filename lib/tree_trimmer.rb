require "tree_trimmer/version"
require "downup"

module TreeTrimmer
  def self.lets_clean_up_some_branches
    puts "\nBranches to Clean:\n\n"
    branches = IO.popen("git branch").each_line.map(&:chomp).map(&:lstrip)
    sanitize_branches!(branches)

    branch_options = ("a".."z").take(branches.count)
      .zip(branches).each_with_object({}) do |option, hash|
        hash[option.first] = option.last
      end

    puts selection = Downup::Base.new(
      options: branch_options,
      type: :multi_select
    ).prompt
  end

  def self.sanitize_branches!(branches)
    branches.each do |branch|
      if branch.include?("master")
        branches.delete(branch)
      end
    end
  end
end

TreeTrimmer.lets_clean_up_some_branches
