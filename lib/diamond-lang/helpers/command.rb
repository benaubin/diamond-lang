# say ...
# summon <entity> <coordinates> {entityData}
# gamemode <gamemode> @
# tellraw @ {text}
# blockdata <coordinates> {blockData}
# setblock <coordinates> <block dataValue> [old] {blockData}

module DiamondLang
  module Helpers
    class Command
      attr_accessor :command
      attr_reader :chain
      def initialize(name, *args, &block)
        @command = name.freeze
        @arguments = args.flatten
        if block
          chain = CommandChain.new self
          block.call(chain)
          @chain = chain.commands.freeze
        end
      end
      def to_s
        [@command, *@arguments].join " "
      end
      def inspect
        [@command, *@arguments].join(" ") + ", success: " + @chain.inspect
      end
      def to_minecart
        CommandBlockMinecart.new self
      end
      def to_block(type=:chain)
        CommandBlock.new self, type
      end
    end
  end
end
