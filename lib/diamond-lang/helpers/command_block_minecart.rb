module DiamondLang
  module Helpers
    class CommandBlockMinecart < Entity
      def initialize(command)
        super 'MinecartCommandBlock', {Command: command.to_s}
      end
    end
  end
end
