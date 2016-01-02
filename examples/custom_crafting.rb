require 'diamond-lang'

class CustomCrafting < DiamondLang::OneCommand
  def setup(c)
    c.title s(:a), :subtitle, {"text " => "command by Ben from bensites.com"}.to_json
    c.title s(:a), :title, {"text " => "Custom Crafting"}.to_json
    add_crafting([
      {
        pattern:  "  s"+
                  " p "+
                  "p  ",
        result: "   "+
                " n "+
                "   ",
        n: 'id:"minecraft:name_tag",Count:1b',
        s: 'id:"minecraft:string",Count:1b',
        p: 'id:"minecraft:paper",Count:1b'
      },
      {
        pattern:  "bbb"+
                  "bpb"+
                  "bbb",
        result: "   "+
                " s ",
        b: 'id:"minecraft:iron_bars",Count:1b',
        p: 'id:"minecraft:porkchop",Count:64b',
        s: 'id:"minecraft:mob_spawner",Count:1b'
      }
    ])
  end

  def tick(c)

  end
end

CustomCrafting.create
