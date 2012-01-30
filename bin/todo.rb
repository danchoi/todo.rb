#!/usr/bin/env ruby

require 'todo.rb.rb'

opts = {formatter: :color}
if ARGV[0] == '-C'
  opts[:formatter] = :nocolor
  ARGV.shift
elsif ARGV[0] == '--html'
  opts[:formatter] = :html
  ARGV.shift
end

t = Todo.new opts

args = ARGV.dup

if args.size <= 2 && args.delete('!')

  exec "#{File.expand_path(__FILE__)} #{args.join(' ')} | grep '!'"
end

command = args.shift
has_args = !args.empty?

tag = command && command[/^(@|\+)\S+$/,0]

if tag && has_args
  t.ed_command!('a', [Todo.expand_tag(tag)] + args)
elsif tag 
  t.filter Todo.expand_tag(tag)
elsif command == 'done' && args[0] =~ /^(@|\+)/
  t.filter_done_file  Todo.expand_tag(args[0])
elsif command == 'done'
  t.filter_done_file nil
elsif command == 'all' 
  t.list_all Todo.expand_tag(args[0])
elsif command == 'do' 
  t.mark_done! args[0]
elsif command == 'undo' 
  t.mark_undone! args[0]
elsif command == 'ls' && args.empty?
  t.report
elsif command == 'revert' && args.empty?
  t.revert
elsif command == 'diff' && args.empty?
  t.diff
elsif command.nil?
  t.catn 
else
  t.ed_command! command, *args
end
