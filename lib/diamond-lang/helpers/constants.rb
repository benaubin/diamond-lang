module DiamondLang
  module Helpers
    module Constants
      Variables = {
        closest_player: '@p'.freeze, # Closest player
        random_player: '@r'.freeze, # Random player
        all_player: '@a'.freeze, # All players
        all: '@e'.freeze # All entities
      }.freeze
      Axes = %w[x y z].freeze
    end
  end
end
