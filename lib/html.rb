#!/usr/bin/env ruby
#
require File.join(File.dirname(__FILE__), 'color_config')

def color_span s, color
  "<span style='color:#{color}'>#{s}</span>"
end

COLORS = ColorConfig.new

def colorize s
  s.gsub(/@\S+/) {|m| 
      if COLORS.html(m)
        color_span(m, COLORS.html(m)) 
      else 
        color_span(m, COLORS.html('context'))
      end
    }. gsub(/\+[\S]+/) {|m| 
      if COLORS.html(m)
        color_span(m, COLORS.html(m)) 
      else
        color_span(m, COLORS.html('project'))
      end
    }
end

def mark_priority s
  return s if $no_color
  return s unless  s =~ /!/ 
  s.chomp!
  span =  Regexp.new "<span.*span>"
  s.split(span).map {|a|
    [a, color_span(a, COLORS.html('priority'))]
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
