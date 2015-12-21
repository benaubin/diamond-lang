module DiamondLang
  module Helpers
    class Coordinates
      def initialize(*args)
        @coordinates, args = if args.first.is_a? Coordinate
          args.slice_before{|a| a.is_a? Coordinate }
        else
          axes_args = args.take Constants::Axes.length
          [
            axes_args.zip(Constants::Axes).flat_map do |value, axis|
              Coordinate.new axis, value
            end,
            args.drop(axes_args.length+1)
          ]
        end
      end
      def [](axis)
        @coordinates.select{|coord| coord.axis == axis}[0]
      end
      def x
        self['x'.freeze]
      end
      def y
        self['y'.freeze]
      end
      def z
        self['z'.freeze]
      end
      def to_s
        self.to_fs "{x} {y} {z}".freeze
      end
      def to_fs(format)
        format.gsub(/{(\w)}/) {|match| self[match[1]].value}
      end
      def to_arg
        @coordinates.map {|coord| coord.to_arg}.join ','
      end
    end
  end
end
