#!/usr/bin/env ruby

require 'optparse'
require 'highline'

t = HighLine.new(STDIN, STDOUT)
t.say "Hello <%=color 'world', YELLOW%>"

opts = {}
op = OptionParser.new {|o|
  o.banner = "Usage: todo [options and args]"
  o.separator ""
  o.separator "Specific options:"
  o.on("-a", "--add [task]", "Addon FIELD") { |field| opts[:sort] = field }

  o.on("-h", "--help", "Show this message") { 
    puts o 
    exit
  }
  o.on("-v", "--version", "Show version") { 
    # TODO
    exit
  }
}
op.parse!
user = ARGV.first 
if user.nil?
  $stderr.puts op
  exit 1
end




