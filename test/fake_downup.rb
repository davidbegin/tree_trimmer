module Downup
  class Base
    class << self
      def set_prompt_return(retval)
        @retval = retval
      end

      def new(*)
        @mock = Minitest::Mock.new
        @mock.expect(:prompt, @retval)
      end
    end
  end
end
