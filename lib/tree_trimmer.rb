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
    def initialize(stdin: $stdin, stdout: $stdout)
      @stdin  = stdin
      @stdout = stdout
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

      delete_branches_confirmation
    end

    private

    attr_reader :stdout, :stdin

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

    def delete_branches_confirmation
      stdout.puts "\n\nDelete Branches?\n".red
      stdout.puts @selection
      stdout.print "\n(y/n) > ".light_black
      process_input(stdin.gets.chomp)
    end

    def process_input(input)
      case input
      when "y" then delete_branches!
      when "n" then quit_or_continue
      else
        stdout.puts "please choose y or n"
        delete_branches_confirmation
      end
    end

    def delete_branches!
      @selection.each do |branch|
        cmd = "git branch -D #{branch}"
        stdout.puts "\n...running " + cmd.red + "\n\n"
        system(cmd)
        quit_or_continue
      end
    end

    def quit_or_continue
      stdout.puts ("-" * 80).light_black
      stdout.puts "\nq or quit to abort".light_red
      stdout.puts "c or continue to continue\n".light_yellow
      stdout.print "> "
      case stdin.gets.chomp
      when "q", "quit"
        stdout.puts "\n...thanks for using tree trimmer!".light_cyan
      when "c", "continue"
        trim_branches
      else
        stdout.puts "please choose a relevant option"
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
        stdout.puts "\n------------------"
        stdout.puts "-- Tree Trimmer --"
        stdout.puts "------------------\n\n"
      }
    end
  end
end
