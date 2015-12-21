module DiamondLang
  module Helpers
    class Block
      attr_accessor :id, :data_value, :nbt
      def initialize(id, data_value=0, nbt=nil)
        @id = id
        @data_value = data_value
        @nbt = nbt
      end
      def to_s
        "#{id} #{data_value}#{nbt && " #{nbt.to_json}"}"
      end
    end
  end
end
