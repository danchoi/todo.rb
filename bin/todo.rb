#!/usr/bin/env ruby

require 'todo.rb.rb'

opts = {formatter: :color}
if ARGV[0] == '-C'
  opts[:formatter] = :nocolor
  ARGV.shift
elsif ARGV[0] == '--html'
  opts[:formatter] = :html
  ARGV.shift
elsif ARGV[0] == '-v'
  require 'todo.rb/version'
  puts TodoRb::VERSION  
  exit
elsif ARGV[0] =~ /^--?h/
  require 'todo.rb/help'
  exit
end

t = TodoRb.new opts

args = ARGV.dup

if args.size <= 2 && args.delete('!')

  exec "#{File.expand_path(__FILE__)} #{args.join(' ')} | grep '!'"
end

command = args.shift
has_args = !args.empty?

tag = command && command[/^(@|\+)\S+$/,0]

if tag && has_args
  t.ed_command!('a', [TodoRb.expand_tag(tag)] + args)
elsif tag 
  t.filter TodoRb.expand_tag(tag)
elsif command == 'done' && args[0] =~ /^(@|\+)/
  t.filter_done_file  TodoRb.expand_tag(args[0])
elsif command == 'done'
  t.filter_done_file nil
elsif command == 'all' 
  t.list_all TodoRb.expand_tag(args[0])
elsif command == 'do' 
  t.mark_done! args[0]
elsif command == 'undo' 
  t.mark_undone! args[0]
elsif command == 'report' && args.empty?
  t.report
elsif command == 'revert' && args.empty?
  t.revert
elsif command == 'diff' && args.empty?
  t.diff
elsif command == 'pri' && args[0] =~ /^\d+$/
  t.ed_command! "#{args[0]}s/$/ !/\nm0"
elsif command == 'depri' && args[0] =~ /^\d+$/
  t.ed_command! "#{args[0]}s/!//g\nm/^[^!]*$/-1"
elsif command.nil?
  t.catn 
else
  t.ed_command! command, *args
end
