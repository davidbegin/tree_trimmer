require "tree_trimmer/version"
require "colorize"
require "downup"

module TreeTrimmer
  def self.lets_clean_up_some_branches
    puts "\nBranches to Clean:\n\n"
    Base.new.trim_branches
  end

  private

  class Base
    def initialize
      sanitize_branches!
    end

    def trim_branches
      @selection = Downup::Base.new(
        options: downup_options,
        type: :multi_select,
        multi_select_selector: "x",
        selected_color: :red,
        header_proc: header_proc
      ).prompt

      delete_branches
    end

    private

    def downup_options
      branch_options.zip(branches).each_with_object({}) do |option, hash|
        hash[option.first] = option.last
      end
    end

    def branch_options
      @branch_options ||= ("a".."z").take(branches.count)
    end

    def branches
      @branches ||= IO.popen("git branch").each_line.map(&:chomp).map(&:lstrip)
    end

    def delete_branches
      puts "\n\nDelete Branches?\n".red
      puts @selection
      print "\n(y/n) > ".light_black
      process_input(gets.chomp)
    end

    def process_input(input)
      case input
      when "y"
        @selection.each do |branch|
          cmd = "git branch -D #{branch}"
          puts "\n...running " + cmd.red + "\n\n"
          system(cmd)
          quit_or_continue
        end
      when "n"
        quit_or_continue
      else
        puts "please choose y or n"
        delete_branches
      end
    end

    def quit_or_continue
      puts ("-" * 80).light_black
      puts "\nq or quit to abort".light_red
      puts "c or continue to continue\n".light_yellow
      print "> "
      input = gets.chomp
      case input
      when "q", "quit"
        puts "\n...thanks for using tree trimmer!".light_cyan
        exit
      when "c", "continue"
        trim_branches
      else
        puts "please choose a relevant option"
        quit_or_continue
      end
    end

    def sanitize_branches!
      branches.each do |branch|
        if branch.include?("master")
          branches.delete(branch)
        end
      end
    end

    def header_proc
      proc {
        puts "\n------------------"
        puts "-- Tree Trimmer --"
        puts "------------------\n\n"
      }
    end
  end
end
