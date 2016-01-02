module DiamondLang
  module Helpers
    # Please Note:
    #
    # This class uses the scoreboard objectives:
    # - ask_table
    # - craft_table
    # - on_table
    # - ct_has_block
    # - craft_success
    # And ArmorStands named
    # - CraftingTable
    # - CraftingCreator
    #
    # Including those in your command will break this, and other creations that use this.
    #
    # Do not change the scoreboard objectives ask_table, or on_table.
    # Also, do not change the ArmorStand name "CraftingTable".
    # If you do, you'll risk breaking other creations in the same world.
    #
    #
    # It also creates about 21 commands + 5 for every recipe.
    # On default settings, that's
    # - 1 level
    # - 1 row per recipe
    # - 1 block
    #
    # 2 should be able to be in the same world without any conflict.
    class CustomCrafting
      def initialize(c, recipes)
        @crafting_recipes = recipes
        c.scoreboard :objectives, :add, :ask_table, :dummy, "Asked to Create A Table"
        c.scoreboard :objectives, :add, :craft_table, :trigger, "Creating a Crafting Table"
        c.scoreboard :objectives, :add, :on_table, :trigger, "Players on a crafting table"
        c.scoreboard :objectives, :add, :ct_has_block, :dummy, "Crafting Table with block?"
        c.scoreboard :objectives, :add, :craft_success, :dummy, "Crafting Success:"
      end
      def tick(c)
        c.()
        crafting_table = b('crafting_table')
        stone = b('stone')

        #Enable the on_table trigger
        c.scoreboard :players, :enable, s(:a), :on_table

        #Mark all players on a crafting table pattern
        c.execute s(:a), relative, :detect, coords('~', '~-1', '~'), crafting_table,
          :execute, sp, relative, :detect, coords('~-1', '~-1', '~'), crafting_table,
          :execute, sp, relative, :detect, coords('~1', '~-1', '~'), crafting_table,
          :execute, sp, relative, :detect, coords('~1', '~-1', '~1'), stone,
          :execute, sp, relative, :detect, coords('~1', '~-1', '~-1'), stone,
          :execute, sp, relative, :detect, coords('~-1', '~-1', '~-1'), stone,
          :execute, sp, relative, :detect, coords('~-1', '~-1', '~1'), stone,
          :execute, sp, relative, :detect, coords('~', '~-1', '~1'), crafting_table,
          :execute, sp, relative, :detect, coords('~', '~-1', '~-1'), crafting_table,
          :trigger, :on_table, :set, 1

        #Set all players who are not on a crafting table pattern to ask again once they are
        c.scoreboard :players, :set, s(:a, {score_on_table: 0}), :ask_table, 0

        #Get all players who have not been asked yet and are on a crafting table pattern if they want to build a crafting table
        ask_players = s(:a, {score_on_table_min: 1, score_ask_table: 0})
        c.scoreboard :players, :enable, ask_players, :craft_table
        c.tellraw ask_players, {text: "Build a ", extra: [
          {
            text: "Crafting Table",
            color: "yellow",
            underlined: true,
            clickEvent: {
              action: "run_command",
              value: "/trigger craft_table set 1"
            }
          },
          {
            text: "?"
          }
        ]}.to_json

        invalid_players = s(:a, {score_craft_table_min: 1, score_on_table: 0})

        c.tellraw invalid_players, {text: "Please stand on the ", extra: [
          {text: "Crafting Table Pattern", color: "yellow"},
          {text: " in order to build the "},
          {text: "Crafting Table", color: "yellow"},
          {text: "."}
        ]}.to_json
        c.scoreboard :players, :set, invalid_players, :craft_table, 0

        #Mark all players who have been asked
        c.scoreboard :players, :set, ask_players, :ask_table, 1

        #Get a player that is crafting a table
        player = s(:a, {score_craft_table_min: 1, score_on_table_min: 1, c: 1})

        #Tell the player that it is now building the crafting table
        c.tellraw player, {text: "Now building a ", extra: [
          {text: "Crafting Table", color: "yellow"},
          {text: ". Please hold still for a moment..."}
        ]}.to_json

        c.testfor player do |c|
          c.summon 'ArmorStand', relative, "{CustomName:\"CraftingCreator\",Invisible:1b,Invulnerable:1b,PersistenceRequired:1b,NoGravity:1b,Small:1b}"
        end

        #Teleport the armorstand one block below the player
        armorstand = s(:e, {name: "CraftingCreator", type: 'ArmorStand'})
        c.tp armorstand, player
        c.tp armorstand, "~ ~-1 ~"

        #Remove pattern
        c.execute armorstand, relative, :fill, "~-1 ~ ~-1 ~1 ~ ~1", b('air'), 'replace'

        #Create blocks for crafting table
        c.execute armorstand, relative, :setblock, relative, b('dropper'), :replace, "{CustomName:Crafting Table}"
        c.execute armorstand, relative, :summon, 'ItemFrame', '~ ~ ~-1', "{Facing:2,Item:{id:\"crafting_table\"}}"
        c.execute armorstand, relative, :summon, 'ItemFrame', '~ ~ ~1', "{Facing:4,Item:{id:\"crafting_table\"}}"

        #Reset scores for creating crafting table
        c.scoreboard :players, :reset, player, :craft_table

        c.scoreboard :players, :set, s(:a), :on_table, 0

        #Find Stale Crafting Tables
        crafting_tables = s(:e, {name: "CraftingTable", type: "ArmorStand"})
        c.scoreboard :players, :set, crafting_tables, :ct_has_block, 0
        c.execute crafting_tables, relative, :detect, relative, b("dropper"),
          :scoreboard, :players, :set, s(:e, {name: "CraftingTable", type: "ArmorStand", c: 1, r: 0}), :ct_has_block, 1

        stale_crafting_tables = s(:e, {name: "CraftingTable", type: "ArmorStand", score_ct_has_block: 0})
        c.execute stale_crafting_tables, relative, :tellraw, s(:a, {r: 5}), {
          text: "You destroyed the ", extra: [
            {text: "Crafting Table", color: "yellow"},
            {text: "."}
          ]
        }.to_json
        c.kill stale_crafting_tables

        #Add Recipes
        @crafting_recipes.map do |recipe|
          blockItems, resultItems = [recipe[:pattern], recipe[:result]].map do |str|
            str.split('').each_with_index.map do |letter, i|
              (item = recipe[letter.to_sym]) ? "{" + item + ",Slot:#{i}b}" : nil
            end.compact.join(",")
          end
          {
            block: "{" +
              "Items:[#{blockItems}]," +
              "CustomName:\"Crafting Table\"" +
            "}",
            result: "{" +
              "Items:[#{resultItems}],"+
              "CustomName:\"Crafting Table\""+
            "}"
          }
        end.each do |recipe|
          c.scoreboard :players, :set, crafting_tables, :craft_success, 0
          c.stats :entity, crafting_tables, :set, :SuccessCount, s_self, :craft_success

          c.execute crafting_tables, relative, :testforblock, relative, 'dropper', 0, recipe[:block]

          success_tables = s(:e, {name: "CraftingTable", type: "ArmorStand", score_craft_success_min: 1})

          c.execute success_tables, relative, :blockdata, relative, recipe[:result]

          c.stats :entity, crafting_tables, :clear, :SuccessCount
        end
        c.entitydata armorstand, "{CustomName:CraftingTable}"
      end
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
    end
  end
end
