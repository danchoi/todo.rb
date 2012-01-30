#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'color_config')

gem 'highline', '>= 1.6.11'
require 'highline'

if ARGV[0] == '--no-color'
  $no_color = true
  ARGV.shift
elsif ARGV[0] == '--html'
  $html = true
  ARGV.shift
end

HighLine.color_scheme = HighLine::SampleColorScheme.new
t = HighLine.new(STDIN, STDOUT)
terr = HighLine.new(STDIN, STDERR)

filter = ARGV.first

COLORS = ColorConfig.new

def colorize s
  return s if $no_color
  # color @contexts and +projects
  s.gsub(/@\S+/) {|m| 
      if COLORS.rgb(m)
        "<%= color '#{m}', #{COLORS.rgb(m)} %>" 
      else
        "<%= color '#{m}', #{COLORS.rgb('context')} %>" 
      end
    }.
    gsub(/\+[\S]+/) {|m| 
      if COLORS.rgb(m)
        "<%= color '#{m}', #{COLORS.rgb(m)} %>" 
      else
        "<%= color '#{m}', #{COLORS.rgb('project')} %>" 
      end
    }
end

def mark_priority s
  return s if $no_color
  return s unless  s =~ /!/ 
  s.chomp!
  erb_re =  Regexp.new "<%=.+%>"
  style = COLORS.rgb('priority')
  if s =~ /!!!/ 
    style = ":blink, #{style}"
  end
  s.split(erb_re).map {|a|
    [a, "<%= color '#{a}', #{style} %>"]
  }.each {|(old, new)|
    s.sub!(old, new)
  }
  s
end


while STDIN.gets
  next unless $_
  s = $_ 
  t.say mark_priority(colorize(s))
end

