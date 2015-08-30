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
