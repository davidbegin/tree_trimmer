require "colorize"
require "downup"

module TreeTrimmer
  class Base
    BRANCH_COUNT_LIMIT = 26

    # @param multi_select_selector [String] selector for Downup Menu of when
    #   chosing branches to delete
    # @param selected_color [Symbol] color of selector when chosing a branch to delete
    def initialize(multi_select_selector: "x",
                   selected_color: :red,
                   stdin: $stdin,
                   stdout: $stdout)

      @stdin                 = stdin
      @stdout                = stdout
      @multi_select_selector = multi_select_selector
      @selected_color        = selected_color
      sanitize_branches!
    end

    # Uses the git branches of the current folder
    # to create a Menu with Downup
    #
    # Once branches are choosen,
    # users are prompted to confirm delete the choosen branches.
    #
    # The appropiate action is taken based on the user's input
    # and the deleted or undeleted branches are returned.
    def trim_branches
      @selection = Downup::Base.new(
        options: branch_options,
        type: :multi_select,
        multi_select_selector: multi_select_selector,
        selected_color: selected_color,
        header_proc: header_proc
      ).prompt

      delete_branches_confirmation
      @selection
    end

    private

    attr_reader :stdout, :stdin, :multi_select_selector, :selected_color

    def branch_options
      branch_keys.zip(branches).each_with_object({}) do |option, hash|
        hash[option.first] = option.last
      end
    end

    def branch_keys
      if BRANCH_COUNT_LIMIT > 26
        case
        when branches.count <= 26
          ("a".."z").take(branches.count)
        when branches.count <= 676
          ("aa".."zz").take(branches.count)
        else
          ("aaa".."zzz").take(branches.count)
        end
      else
        ("a".."z").take(branches.count)
      end
    end

    def branches
      IO.popen("git branch").each_line.map(&:chomp).map(&:lstrip)
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
      end
      quit_or_continue_prompt
      quit_or_continue
    end

    def quit_or_continue
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
        branches.delete(branch) if branch.include?("master")
      end
    end

    def quit_or_continue_prompt
      stdout.puts ("-" * 80).light_black
      stdout.puts "\nq or quit to abort".light_red
      stdout.puts "c or continue to continue\n".light_yellow
      stdout.print "> "
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
