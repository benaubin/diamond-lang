require 'diamond-lang'
require 'json'

class Conveyor < DiamondLang::OneCommand
  def setup(c)
    c.title s(:a), :subtitle, {"text " => "command by Ben from bensites.com"}.to_json
    c.title s(:a), :title, {"text " => "Conveyor Belts"}.to_json
  end
  def tick(c)
    black_carpet = b 'carpet', colors(:black)
    pistons = (2..5).map {|d| [d, b('piston', d)]}.each do |d, piston|
      c.execute s(:e), relative,
        :detect, relative, black_carpet,
        :execute, s_self, relative,
        :detect, coords('~', '~-1', '~'), piston,
        :tp, s_self,  (d == 2 && "~ ~ ~-.2" ) ||
                  (d == 3 && "~ ~ ~.2") ||
                  (d == 4 && "~-.2 ~ ~") ||
                  (d == 5 && "~.2 ~ ~")
    end
  end
end

Conveyor.create
