module DiamondLang
  module Errors
    class InvalidCoordinateValue < StandardError
      def initialize(value)
        super "#{value} isn't a valid coordinate."
      end
    end
  end
end
