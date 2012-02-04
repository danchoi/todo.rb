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

if args.size == 1 && args.delete('l')
  exec "#{File.expand_path(__FILE__)} #{args.join(' ')} | less -R"
end

if args[0] =~ /^-\d+$/ 
  range = args.shift
  exec "#{File.expand_path(__FILE__)} #{args.join(' ')} | head #{range}"
end

command = args.shift
has_args = !args.empty?
rest_args = args.join(' ')

tag = command && command[/^(@|\+)\S+$/,0]

if tag && has_args
  c = args.join =~ /!/ ? '0i' : 'a'
  t.ed_command!(c, [TodoRb.expand_tag(tag)] + args)
elsif tag 
  t.filter tag:TodoRb.expand_tag(tag)
elsif command == 'done' && args[0] =~ /^(@|\+)/
  t.filter tag:TodoRb.expand_tag(args[0]), list: :done
elsif command == 'done'
  t.filter list: :done
elsif command == 'all' 
  t.list_all TodoRb.expand_tag(args[0])
elsif command == 'do' 
  t.mark_done! args[0]
elsif command == 'undo' 
  t.mark_undone! args[0] # can be number or /regex/
elsif command == 'report' && args.empty?
  t.report
elsif command == 'revert' && args.empty?  # not necessary, really
  t.revert
elsif command == 'diff' && args.empty? # rarely used
  t.diff
elsif command == 'pri' && args[0] 
  t.ed_command! "#{args[0]}s/$/ !/\nm0"
elsif command == 'depri' && args[0] 
  t.ed_command! "#{args[0]}s/ *!//g\nm/^[^!]*$/-1"
elsif command =~ /e(dit)?$/  
  t.external_edit rest_args
elsif command.nil?
  t.filter
else
  t.ed_command! command, *args
end
