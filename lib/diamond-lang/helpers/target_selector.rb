module DiamondLang
  module Helpers
    class TargetSelector
      attr_accessor :arguments
      def initialize(variable, arguments={})
        @variable, @arguments = "@#{variable}", arguments
      end
      def <<(arguments)
        @arguments = @arguments.merge arguments
      end
      def to_s
        if @arguments.empty?
          @variable
        else
          @variable + "[" + mc_args + "]"
        end
      end
      alias inspect to_s
      def mc_args
        @arguments.map { |arg, val| val.to_arg arg }.join ','
      end
    end
  end
end

class Object
  def to_arg(arg)
    arg.to_s + "=" + self.to_s
  end
end
