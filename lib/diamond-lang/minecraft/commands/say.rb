module DiamondLang
  module Minecraft
    module Commands
      class Say < Helpers::Command
        def initialize
          super 'say', Helpers::CommandParts::Text
        end
        def call(*args)
          
        end
      end
    end
  end
end
