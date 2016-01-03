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
    c.scoreboard :objectives, :add, :jetpack, :dummy, "Holding Jetpack"
    c.scoreboard :objectives, :add, :sneaking, "stat.sneakTime", "Sneaking"
    c.scoreboard :objectives, :add, :jetpack_speed, :dummy, "Jetpack Speed"
  end

  def tick(c)
    not_sneaking = s(:a, {score_jetpack_min: 1, score_sneaking: 0})
    sneaking = s(:a, {score_jetpack_min: 1, score_sneaking_min: 1})

    c.scoreboard :players, :set, s(:a), :jetpack, 0
    c.scoreboard :players, :set, s(:a), :jetpack, 1, "{Inventory:[{#{@jetpack},Slot:102b}]}"
    jetpack_players = s(:a, {score_jetpack_min: 1})

    c.scoreboard :players, :add, sneaking, :jetpack_speed, 1
    c.scoreboard :players, :set, not_sneaking, :jetpack_speed, 0

    {
      0 => 0,
      1 => 5,
      5 => 7,
      10 => 10,
      20 => 15,
      30 => 25,
      40 => 30,
      50 => 35,
      60 => 40,
      70 => 45,
      80 => 46,
      90 => 47,
      100 => 48,
      110 => 49,
      120 => 50
    }.each do |time, level|
      c.effect s(:a, {score_jetpack_min: 1, score_jetpack_speed_min: time}), "minecraft:levitation", level == 0 ? 0 : 1, level
    end

    c.scoreboard :players, :set, s(:a), :sneaking, 0
  end
end

Jetpack.create
