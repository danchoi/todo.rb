#!/usr/bin/env ruby

CONTEXT_COLOR = 'cyan'
PROJECT_COLOR = 'red'


def color_span s, color
  "<span style='color:#{color}'>#{s}</span>"
end

def colorize s
  s.gsub(/@\S+/) {|m| color_span(m, CONTEXT_COLOR) }.
    gsub(/\+[\S]+/) {|m| color_span(m, PROJECT_COLOR) }
end

def mark_priority s
  return s if $no_color
  return s unless  s =~ /!/ 
  s.chomp!
  span =  Regexp.new "<span.*span>"
  color = s =~ /!!!/ ?  'yellow' : 'yellow'  # change
  s.split(span).map {|a|
    [a, color_span(a, color)]
  }.each {|(old, new)|
    s.sub!(old, new)
  }
  s
end

puts "<pre style='color:#08FF08;font-family:Andale Mono;background-color:black'>\n\n"
while STDIN.gets
  next unless $_
  s = $_ 
  puts mark_priority(colorize(s))
end

puts "\n</pre>"
