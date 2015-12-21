module DiamondLang
  module Errors
    class RelativeCordinateConvertedToArgument < StandardError
      def initialize
        super "A relative cordinate was converted to an argument."
      end
    end
  end
end
