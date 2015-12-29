# /summon FallingSand ~ ~1 ~
# {
#   Block:stone,
#   Time:1, Passengers:[
#     {
#       id:FallingSand,
#       Block:redstone_block,
#       Time:1,
#       Passengers:[

module DiamondLang
  module Helpers
    class Entity
      attr_reader :id
      attr_accessor :data
      def initialize(id, data={})
        @id = id
        data[:Passengers] ||= []
        @data = data
      end
      def passengers
        data[:Passengers]
      end
      def passengers=(v)
        data[:Passengers]=(v)
      end
      def to_h
        data = @data.dup
        data[:id] = @id
        data[:Passengers] = data[:Passengers].map{ |passenger| passenger.to_h }
        data.delete :Passengers if data[:Passengers].empty?
        data
      end
      def summon(coords)
        data = @data.dup
        data[:Passengers] = data[:Passengers].map{ |passenger| passenger.to_h }
        Command.new 'summon'.freeze, @id, coords.to_s, data.to_json
      end
      def selector(args={})
        args[:type] = @id
        TargetSelector.new(:e, args)
      end
    end
  end
end
