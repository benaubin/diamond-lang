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
        @data = data
      end
      def passengers
        data[:passengers]
      end
      def passengers=(v)
        data[:passengers]=(v)
      end
      def json
        data = data.dup
        data.id = @id
        data
      end
      def summon(coords)
        data = data.dup
        data.passengers = data.passengers.map{ |passenger| passenger.json }
        Command.new 'summon'.freeze, @id, data, coords.to_s
      end
      def selector(args={})
        args.type = @id
        TargetSelector.new :e, args
      end
    end
  end
end
