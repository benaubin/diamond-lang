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
