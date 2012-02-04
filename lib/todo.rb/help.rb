puts <<END

todo.rb
-------

todo.rb is a command line todo list manager.

The full guide is located at\nhttp://danchoi.github.com/todo.rb/

todo.rb operates in the current working directory. It will create a todo.txt
and done.txt file to store tasks.

The following assumes that `alias t=todo.rb` is in effect.

A [tag] may be a @context or a +project. 

And [task address] can be a line number or a regular expression that matches
the task.

t [tag] [task text]     append a task with tag
t                       show tasks
t [ed command]          perform ed command on todo list
t e [task address]      edit task at [task address] in external EDITOR
t e                     edit entire task list in external EDITOR
t l                     pipe entire list to `less -R`
t done                  show done tasks
t do [task address]     move a task to the done.txt
t undo [task address]   move a task from done.txt to todo.txt
t [tag]                 filter tasks by tag
t pri [task address]    prioritize a task
t depri [task address]  deprioritize a task
t !                     show high priority tasks 
t ! [tag]               show high priority tasks for a tag
t report                show task report
t all                   list all incomplete and done tasks
t all [tag]             ditto, but filter by tag


Tag colors can be customized in colors.yml. It may look something like this.

    priority: fuchsia
    context: FF69B4
    project: FFEBCD
    @harvardsq: DDAA00


END
