module DiamondLang
  module Helpers
    class CommandBlock < Block
      Types = {
        chain: 'chain_command_block',
        impulse: 'command_block',
        repeating: 'repeating_command_block'
      }.freeze
      def direction
        conditional? ? @data_value - 8 : @data_value
      end
      def direction=(val)
        @data_value = val + (conditional? ? 8 : 0)
      end
      def initialize(command,type=:chain,data_value=0,auto=true,conditional=false)
        super Types[type], data_value, {
          Command: command.to_s,
          auto: auto
        }
        conditional = conditional
      end
      def type=(type)
        @id = Types[type]
      end
      def type
        Types.reverse[@id]
      end
      def conditional=(val)
        if conditional? && !val
          @data_value -= 8
        elsif !@conditional && val
          @date_value += 8
        end
      end
      def conditional?(data_value=@data_value)
        data_value >= 8
      end
    end
  end
end
class Hash
  def reverse
    self.to_a.map{|i| i.reverse}.to_h
  end
end
