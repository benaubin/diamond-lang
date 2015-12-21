require 'json'

module DiamondLang
  class CommandChain
    attr_reader :commands
    def initialize(parent)
      @parent = parent
      @commands = []
    end
    def method_missing(name, *args, &block)
      @commands << Helpers::Command.new(name.to_s.downcase, args, &block)
    end
  end
end
