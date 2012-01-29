#!/usr/bin/env ruby
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

CONTEXT_COLOR = 'CYAN'
PROJECT_COLOR = 'RED'

def colorize s
  return s if $no_color
  # color @contexts and +projects
  s.gsub(/@\S+/) {|m| "<%= color '#{m}', #{CONTEXT_COLOR} %>" }.
    gsub(/\+[\S]+/) {|m| "<%= color '#{m}', #{PROJECT_COLOR} %>" }
end

def mark_priority s
  return s if $no_color
  return s unless  s =~ /!/ 
  s.chomp!
  erb_re =  Regexp.new "<%=.+%>"
  style = s =~ /!!!/ ?  ':blink, :warning' : ':warning' 
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

