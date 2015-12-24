module DiamondLang
  module Helpers
    class Block
      attr_accessor :id, :data_value, :nbt
      def initialize(id, data_value=0, nbt=nil)
        @id = id
        @data_value = data_value
        @nbt = nbt
      end
      def to_s(replace_method=nil)
        [id, data_value, replace_method, nbt.to_json].select{|e| e && e != 'null'}.join(' ')
      end
      def to_falling_sand
        FallingSand.new self
      end
    end
  end
end
