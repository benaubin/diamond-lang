module DiamondLang
  module Errors
    class TooSmall < StandardError
      def initialize
        super "Could not fit all commands in the area you selected."
      end
    end
  end
end
