module DiamondLang
  module Helpers
    class Coordinate
      attr_reader :axis
      def initialize(axis, v, relative=v.is_a?(String)&&v.include?('~'))
        raise Errors::InvalidAxis.new(axis) unless Constants::Axes.include? (axis = axis.to_s.downcase)
        @axis = axis
        self.value=(v)
        @relative = relative
      end
      def value=(value)
        @value = if value.is_a? Integer
          value
        elsif value.is_a?(String) && /^(?<rel>~)?(?<number>\d+)?$/ =~ value
          @relative = rel
          number.to_i
        else
          raise Errors::InvalidCoordinateValue.new value
        end
      end
      def +(amount)
        @value += amount
      end
      def -(amount)
        @value -= amount
      end
      def _value=(value)
        @value = value
      end
      def _value
        @value
      end
      def value
        (@relative ? '~' : '') + @value.to_s
      end
      alias to_s value
      def to_arg
        raise Errors::RelativeCordinateConvertedToArgument if @relative
        "#{@axis}=#{@value}".freeze
      end
      def inspect
        "#{self.class.to_s}(" + @axis + ": " + value + ")"
      end
    end
  end
end
