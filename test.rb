require 'highline'

t = HighLine.new(STDIN, STDOUT)
t.say "Hello <%=color 'world', YELLOW%>"
