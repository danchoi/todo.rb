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



    todo pri


<pre style='color:#08FF08;font-family:Andale Mono;background-color:black'>

     1	html output option
     2	<span style='color:#DC143C'>+todo.rb</span> color configuration option
<span style='color:#FFFF00'>     3	buy tea bags! </span><span style='color:#9400D3'>@cambridgeport</span>
     4	make better email response system for <span style='color:#DC143C'>+kindlefeeder</span> <span style='color:#DC143C'>+kaja</span>
     5	<span style='color:#DC143C'>+todo.rb</span> make help a command with output
     6	<span style='color:#9400D3'>@cambridgeport</span> buy toothpaste
<span style='color:#FFFF00'>     7	</span><span style='color:#DC143C'>+kaja</span><span style='color:#FFFF00'> dogood facebook!</span>
     8	<span style='color:#ECECEC'>@email</span> email nate back
<span style='color:#FFFF00'>     9	</span><span style='color:#ECECEC'>@harvardsq</span><span style='color:#FFFF00'> get work done!</span>
    10	<span style='color:#DC143C'>+todo.rb</span> README

</pre>

