# todo.rb

**NOTE** this is a work in progress. Not meant yet to be a working tool.

A lightweight command line todo list application, inspired by
[todo.txt][todo.txt] and written with Ruby.

[todo.txt]:http://ginatrapani.github.com/todo.txt-cli/

The philosphy behind todo.rb is to fill the gap between existing Unix tools and
a convenient todo list system with as little code as possible.

If you want to use todo.rb, you will also have to learn a little `ed` and
`cat`.  There is no point in reinventing the wheel where Unix gives you good
wheels.


## Data format

todo.rb keeps all your tasks in two text files, `todo.txt` and `done.txt` in
the current working directory. 

## Add a task

    cat >> todo.txt
    type your one-line task here
    [press CTRL-D to save and exit]

Instead of `cat`, you can also use any text editor, but cat is probably the
most efficient and the least obtrusive.

## List all tasks

    cat -n todo.txt




