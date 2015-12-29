module DiamondLang
  class OneCommand
    def self.instance
      @@instance
    end
    def self.create(*args)
      @@instance = self.new(*args)
      puts @@instance.to_command.to_s.gsub(/\\?"(\w+?)\\?":/, '\1:').gsub(/(\\?"\w+?)\s(\\?":)/, '\1\2')
    end
    def initialize(height=5, length=6, width=5, offset=coords(2, 2, 0), surrond=Helpers::Block.new('stained_hardened_clay', 13), output=false)
      @output = output
      @height = height # y
      @width = width # z
      @length = (length / 2).floor * 2 # x
      puts "WARNING: The length of your command block needs to be even. Rounding down to #{@length}." unless length.even?
      @offset = offset.freeze
      @corner1 = coords("~#{@offset.x}", "~#{@offset.y}", "~#{@offset.z}").freeze
      @corner2 = coords("~#{@offset.x._value + @length}", "~#{@offset.y._value + @height}", "~#{@offset.z._value + @width}").freeze
      @surrond = surrond
    end
    def startup(c)
      c.gamerule(:commandBlockOutput, @output)
      c.fill @corner1.to_s, @corner2.to_s, @surrond.to_s, 'hollow' if @surrond
    end
    def cleanup(c)
      c.setblock "~ ~ ~1 command_block 0 replace {Command:fill ~ ~-1 ~-1 ~ ~ ~ air}"
      c.setblock "~ ~-1 ~1 redstone_block"
      c.kill e('MinecartCommandBlock').selector({r: 1})
    end
    def create_commands(c)
      chain = CommandChain.new self
      tick chain
      commands = chain.commands.map do |command|
        command.to_block
      end
      command_lines = commands.each_slice(@length - 1).each_with_index.map do |line, z|
        direction = z.even? ? 5 : 4
        line.map! do |c|
          c.direction = direction
          c
        end
      end
      command_levels = command_lines.each_slice(@width - 1).each_with_index.map do |level, y|
        level = level.map! do |line|
          line.last.direction = y.even? ? 3 : 2
          line
        end
        level.last.last.direction = 1
        level = level.each_with_index.map do |line, z|
          z.even? ? line : line.reverse
        end
        y.even? ? level : level.reverse
      end
      command_levels.first.first.first.type = :repeating
      raise Errors::TooSmall if command_levels.to_a.length > (@height - 1)
      command_levels.each_with_index do |level, y|
        level.each_with_index do |line, z|
          z += @width - 1 - level.length if y.odd?
          line.each_with_index do |command, x|
            x += @length - 1 - line.length unless y.odd? == z.odd?
            c.setblock coords(
                        "~#{x + @corner1.x._value + 1}",
                        "~#{y + @corner1.y._value + 1}",
                        "~#{z + @corner1.z._value + 1}"
                       ), command.to_s(:replace)
          end
        end
      end
    end
    def chain
      chain = CommandChain.new self
      startup chain
      setup chain
      create_commands chain
      cleanup chain
      chain
    end
    def to_command
      activator_rail = b('activator_rail').to_falling_sand
      redstone_block = b('redstone_block').to_falling_sand
      activator_rail.passengers.push *chain.to_minecarts
      redstone_block.passengers << activator_rail
      redstone_block.summon coords('~', '~1', '~')
    end
    def setup(c)
      puts "Warning: You haven't implimented a setup function."
    end
    def tick(c)
      puts "Warning: You haven't implimented a tick function."
    end
    private
    def b(*args)
      Helpers::Block.new(*args)
    end
    def e(*args)
      Helpers::Entity.new(*args)
    end
    def s(*args)
      Helpers::TargetSelector.new(*args)
    end
    def sp
      s :p
    end
    def s_self
      s :e, {r: 0, c: 1}
    end
    def coords(*args)
      Helpers::Coordinates.new(*args)
    end
    def relative
      coords('~', '~', '~')
    end
    def colors(color)
      {
        white: 0,
        orange: 1,
        magenta: 2,
        light_blue: 3,
        yellow: 4,
        lime: 5,
        pink: 6,
        grey: 7,
        light_grey: 8,
        cyan: 9,
        purple: 10,
        blue: 11,
        brown: 12,
        green: 13,
        red: 14,
        black: 15
      }.freeze[color]
    end
  end
end
