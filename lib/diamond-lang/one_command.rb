module DiamondLang
  class OneCommand
    def initialize(output=false, surrond=Helpers::Block.new('stained_hardened_clay', 13))
      @commands = []
      @commands << Helpers::Command.new('gamerule', commandBlockOutput: output)
      @commands << Helpers::Command.new('fill', '%{area}', surrond, 'hollow') if surrond
      "fill ~2 ~-3 ~-1 ~4 ~-1 ~1 #{surrond} hollow" if surrond
    end
    def add_command (name, &block)
      define_method name, &block
    end
    def setup_commands
      chain = CommandChain.new self
      setup chain
      chain.commands
    end
    def to_command
      setup_commands
    end
    def setup(c)
      puts "Warning: You haven't implimented a setup function."
    end
    def tick(c)
      puts "Warning: You haven't implimented a tick function."
    end
    private
    def s(*args)
      Helpers::TargetSelector.new(args)
    end
    def coords(*args)
      Helpers::Coordinates.new(args)
    end
  end
end
