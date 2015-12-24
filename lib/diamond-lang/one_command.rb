module DiamondLang
  class OneCommand
    def self.create(*args)
      instance = self.new(*args)
    end
    def initialize(hieght=5, length=6, width=5, offset=coords('2', '2', '0'), surrond=Helpers::Block.new('stained_hardened_clay', 13))
      @height = hieght # y
      @width = width # z
      puts "WARNING: The length of your command block needs to be even. Rounding down." unless length % 2 != 0
      @length = (length / 2).floor * 2 # x
      @offset = offset
      @corner1 = coords("~#{@offset.x}", "~#{@offset.y}", "~#{@offset.z}").freeze
      @corner2 = @corner1.dup
      @corner2.x + @length
      @corner2.y + @height
      @corner2.z + @width
      @corner2.freeze
      @innerCorner1 = @corner1.dup
      @innerCorner1.x + 1
      @innerCorner1.y + 1
      @innerCorner1.z + 1
      @innerCorner1.freeze
      @innerCorner2.x - 1
      @innerCorner2.y - 1
      @innerCorner2.z - 1
      @innerCorner2.freeze
      @surrond = surrond
    end
    def startup(c)
      c.gamerule({commandBlockOutput: @output})
      c.fill @corner1.to_s, @corner2.to_s, @surrond.to_s, 'hollow' if @surrond
    end
    def cleanup(c)
      c.kill e('MinecartCommandBlock').selector({r: 1})
    end
    def create_commands(c)
      chain = CommandChain.new self
      tick chain
      commands = chain.commands.map do |command|
        command.to_block
      end
      command_lines = commands.each_slice(@length - 2)
      command_lines.each_with_index.map do |line, z|
        direction = 4 + (z % 2)
        end_block = line[-1]
        end_block.direction = direction - 2
        line[0..-2].map{|command|command.direction = direction}.push end_block
      end
      command_levels = commands.each_slice(@width - 2)
      command_levels.map do |level|
        level.last.last.direction = 1 unless level == command_levels[-1]
      end
      raise Errors::TooSmall if command_levels.length > (@height - 2)
      c.setblock block_cords, command.to_s(replace_method: :replace)
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
      stone = b('stone').to_falling_sand
      activator_rail.passengers.push(*chain.commands.map{|command| command.to_minecart})
      redstone_block.passengers << activator_rail
      stone.passengers << redstone_block
      stone.summon c('~', '~1', '~')
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
      Helpers::TargetSelector.new(args)
    end
    def coords(*args)
      Helpers::Coordinates.new(args)
    end
  end
end
