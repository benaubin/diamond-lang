module DiamondLang
  module Errors
    class InvalidAxis < StandardError
      def initialize(axis)
        super "A cordinate was created with an axis of #{axis}, which isn't in: [#{Helpers::Constants::Axes.join(', ')}]"
      end
    end
  end
end
