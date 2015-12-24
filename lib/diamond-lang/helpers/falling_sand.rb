module DiamondLang
  module Helpers
    class FallingSand < Entity
      def initialize(block=Block.new('sand'), time=1)
        super 'FallingSand', {
          Block: block.id,
          Time: time,
          Data: block.data_value
        }
      end
    end
  end
end
