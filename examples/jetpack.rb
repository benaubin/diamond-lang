require 'diamond-lang'

class Jetpack < DiamondLang::OneCommand
  def setup(c)
    c.title s(:a), :subtitle, {"text " => "command by Ben from bensites.com"}.to_json
    c.title s(:a), :title, {"text " => "Jetpack"}.to_json
    @jetpack = 'id:"minecraft:elytra",Count:1b,tag:{display:{Name:Jetpack,Lore:[A jetpack that,lets you fly!]}}'
    add_crafting([
      {
        pattern:  "rrr"+
                  "rer"+
                  "fff",
        result: "   "+
                " j "+
                "   ",
        r: 'id:"minecraft:redstone",Count:1b',
        e: 'id:"minecraft:elytra",Count:1b',
        f: 'id:"minecraft:fire_charge",Count:1b',
        j: @jetpack
      }
    ])
    c.scoreboard :objectives, :add, :jetpack, :dummy, "Is holding a jetpack."
  end

  def tick(c)
    c.scoreboard :players, :set, s(:a), :jetpack, 0
    c.scoreboard :players, :set, s(:a), :jetpack, 1, "{SelectedItem:{#{@jetpack}}}"
    c.effect s(:a, {score_jetpack_min: 1}), "minecraft:levitation", 1, 10
  end
end

Jetpack.create
