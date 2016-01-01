#Diamond Lang
Diamond Lang is a minimal framework for Ruby that compiles into Minecraft One Command Creations.

#Installation:

DiamondLang is a Ruby Gem.

##Ruby
DiamondLang is tested to work on Ruby 2.2.X. If you don't have Ruby 2.2.X, but know how to install it, do so in your preferred way. Otherwise, read on:

###Mac Or Linux

Open Terminal (or your equivalent, on Linux) and type:

~~~sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
~~~

###Windows
Go to <http://rubyinstaller.org> and download the correct version of Ruby.

##Gem

You should have [ruby gems][gems], which allows you to download gems. To install diamond lang, type the following in your terminal:

~~~sh
gem diamond-lang
~~~

Now, you're good to go.


---

#Getting Started
Using diamond lang is simpler then command blocks, although we'd recommend learning [a bit of ruby first][try-ruby] - that guide will only take 15 minutes, and is completely optional.

Once you've read that, we'll create a Hello World program that will say "Hello World" when the command is pasted into the world.

First, we'll include diamond lang, so that we can create a command.

~~~rb
require 'diamond-lang' # Requires DiamondLang
~~~

Next, we'll create our command. The name of your command should have no spaces, and the start of each word should be capitalized. So, we'll name our "Hello World" command "HelloWorld". It should also extend (`<`) `DiamondLang::OneCommand`.

~~~rb
require 'diamond-lang'
class HelloWorld < DiamondLang::OneCommand
end
~~~

To run a command at setup, create a `#setup` method:

~~~rb
require 'diamond-lang'
class HelloWorld < DiamondLang::OneCommand
  def setup(c)

  end
end
~~~

We're asking for the variable `c`, which is our command block chain. To attach a command, we call it as if it was a method on `c`:

~~~rb
...
def setup(c):
  c.tell 'penne12', 'it worked!' #=> 'tell penne12 it worked!'
end
...
~~~

At the end of the code you wrote, run `{YourCommandName}.create`

~~~rb
require 'diamond-lang'
class HelloWorld < DiamondLang::OneCommand
  def setup(c)
    c.tell 'penne12', 'it worked!' #=> 'tell penne12 it worked!'
  end
end
HelloWorld.create
~~~

to run your code  

---


#Helpers
To make your life easier, we implemented these features to mimic parts of Minecraft, and commonly used idioms:

##Commands
Commands are attached to a chain (`c`), and arguments are separated with commas (`,`):

###Examples:

~~~rb
c.say "hi" #=> say hi
c.tell "penne12", "it works!" #=> tell penne12 it works
~~~

##Selectors
Entity/Player selectors are created with `#s`, and can be used as arguments in commands:

###Examples:

~~~rb
s(:p) #=> @p
s(:a) #=> @a (etc)
s(a: {r: 1}) #=> @a[r=1]
s(p: {c: 2}) #=> @p[c=2]
s(p: {x: 5, y: 64, z: 5}) #=> @p[x=5,y=64,z=5]
~~~

##Coordinates:
Coordinates can be created with `#coords`:

###Examples:

~~~rb
coords(4, 5, 6) #=> x: 4, y: 5, z: 6
coords('~', '~5', '~') #=> x: ~0, y: 5, z: ~0
~~~

You can also get a coordinate:

~~~rb
coords(4, 5, 6).z #=> DiamondLang::Helpers::Coordinate(z: 6)
coords(4, 5, 6).y #=> DiamondLang::Helpers::Coordinate(y: 5)
coords(4, 5, 6).x #=> DiamondLang::Helpers::Coordinate(x: 4)

test = coords(4, 5, 6) #=> coords(4, 5, 6)
text.x + 5 #=> 9
test #=> coords(9, 5, 6)
~~~

##Coordinate:
A single coordinate on the x, y, or z axis.

You can run `+` or `-`, which adds/substracts to the coordinate respectively.

###Examples:

~~~rb
DiamondLang::Helpers::Coordinate(:x, 6) #=> x: 3
DiamondLang::Helpers::Coordinate(:x, 6) + 5 #=> 11
#=> Command Block: 						test_for @a[r=10]
#=> Chained conditional command block: 	tell @a[r=10] hello
~~~

##Conditions:
To make commands run on success, attach a block:

~~~rb
c.test_for s(a: {r: 10}) do |c|
  c.tell s(a: {r: 10}), 'hello'
end
#=> Command Block: 						test_for @a[r=10]
#=> Chained conditional command block: 	tell @a[r=10] hello
~~~

##Plain Ruby:
Diamond Lang is just a Ruby framework, so you can have awesome things, like variables:

~~~rb
close_players = s(a: {r: 10})
c.test_for close_players do |c|
  c.tell close_players, 'hello'
end #=> @a[r=10]
~~~

hashes instead of arrays (we flatten the command arguments)

~~~rb
c.tell penne12: 'something' #=> tell penne12 something
~~~

string interpolation:

~~~rb
c.tell penne12: "2 + 2 is #{2 + 2}" #=> tell penne12 2 + 2 is 4
~~~

loops to ease the creation of commands:

~~~rb
(5..10).each do |number|
  c.tell 'penne12', number
end #=> tell penne12 5, tell penne12 6, tell penne12 7, tell penne12 8, tell penne12 9, tell penne12 10
~~~

and more.

[gems]: https://rubygems.org
