module DiamondLang
  class OneCommand
    def self.instance
      @@instance
    end
    def self.create(*args)
      @@instance = self.new(*args)
      puts @@instance.to_command
    end
    def self.create_not_strict(*args)
      @@instance = self.new(*args)
      puts @@instance.to_command.to_s.gsub(/\\?"(\w+?)\\?":/, '\1:')
    end
    def initialize(hieght=5, length=6, width=5, offset=coords(2, 2, 0), surrond=Helpers::Block.new('stained_hardened_clay', 13))
      @height = hieght # y
      @width = width # z
      @length = (length / 2).floor * 2 # x
      puts "WARNING: The length of your command block needs to be even. Rounding down to #{@length}." unless length % 2 == 0
      @offset = offset
      @corner1 = coords("~#{@offset.x}", "~#{@offset.y}", "~#{@offset.z}").freeze
      @corner2 = coords("~#{@offset.x + @length}", "~#{@offset.y + @height}", "~#{@offset.z + @width}").freeze
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
      end.reverse
      command_lines = commands.each_slice(@length - 2).each_with_index.map do |line, z|
        direction = 4 + (z % 2)
        end_block = line[-1]
        end_block.direction = direction - 2
        line[0..-2].map{|command|command.direction = direction}.push end_block
      end.reverse
      command_levels = command_lines.each_slice(@width - 2).map do |level|
        level.last.last.direction = 1 unless level == command_levels.to_a[-1]
        level
      end.reverse
      raise Errors::TooSmall if command_levels.to_a.length > (@height - 2)
      command_levels.each_with_index do |level, y|
        level.each_with_index do |row, z|
          row.each_with_index do |command, x|
            c.setblock coords("~#{@offset.x + x - 1}", "~#{@offset.y + y - 1}", "~#{@offset.z + z - 1}"), command.to_s(:replace)
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
      activator_rail.passengers.push(*chain.commands.map{|command| command.to_minecart})
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
    def coords(*args)
      Helpers::Coordinates.new(*args)
    end
  end
end
