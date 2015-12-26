=begin
/summon FallingSand ~ ~1 ~
{
  Block:stone,
  Time:1, Passengers:[
    {
      id:FallingSand,
      Block:redstone_block,
      Time:1,
      Passengers:[
        {
          id:FallingSand,
          Block:activator_rail,
          Time:1,
          Passengers:[
            {
              id:MinecartCommandBlock,
              Command: gamerule commandBlockOutput false
            },
            {
              id:MinecartCommandBlock,
              Command: "fill ~2 ~-3 ~-1 ~4 ~-1 ~1 stained_hardened_clay 13 hollow"
            },
            {
              id:MinecartCommandBlock,
              Command:"fill ~2 ~-2 ~-1 ~4 ~-2 ~1 stained_glass 12 replace stained_hardened_clay"
            },
            {
              id:MinecartCommandBlock,
              Command:"scoreboard objectives add IqWApo_I dummy"
            },
            {
              id:MinecartCommandBlock,
              Command:setblock ~3 ~-2 ~ repeating_command_block 5 replace {
                auto:1,Command:"say Hello World"
              }
            },
            {
              id:MinecartCommandBlock,
              Command:setblock ~ ~ ~1 command_block 0 replace {
                Command:fill ~ ~-3 ~-1 ~ ~ ~ air
              }
            },
            {
              id:MinecartCommandBlock,
              Command:setblock ~ ~-1 ~1 redstone_block
            },
            {
              id:MinecartCommandBlock,
              Command:kill @e[type=MinecartCommandBlock,r=1]
            }
          ]
        }
      ]
    }
  ]
}
=end
require 'diamond-lang'

class HelloWorld < DiamondLang::OneCommand
  def setup(c)
    c.say "Hello World" #=> /say Hello World
  end
  def tick(c)
    c.say "Hello World! I can count to 10:" #=> /say Hello World! I can count to 10:
    (1..10).each do |n|
      c.say n #=> 10 times: /say n
    end
  end
end

HelloWorld.create
