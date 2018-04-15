require 'zeus'
require 'thor'

module Zeus
 class CLI < Thor
  desc "hello world", "my first cli yay"
  def hello(name)
    if name == "Heisenberg"
      puts "you are goddman right"
    else
      puts "say my name"
    end
  end

  desc "search", "search options"
  def search
    puts "Hello world"
  end
 end
end
