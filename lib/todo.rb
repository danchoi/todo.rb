
COLORIZER = File.join(File.dirname(__FILE__), 'colorizer.rb')

class Todo

  attr_accessor :todo_file, :done_file, :backup_file, :colorizer

  def initialize(opts={})
    # TODO may read from .todorc
    defaults = { 
      todo_file: 'todo.txt',
      done_file: 'done.txt'
    }
    @opts = defaults.merge opts
    @colorizer = @opts[:color] ? COLORIZER : "#{COLORIZER} --no-color"
    @todo_file = @opts[:todo_file]
    @backup_file = ".#{@todo_file}.bkp"
    @done_file = @opts[:done_file]
    make_files
  end

  def make_files
    [todo_file, done_file].each do |f|
      if !File.exist?(f)
        $stderr.puts "Missing a #{f} file. Creating."
        `touch #{f}`
      end
    end
  end

  def backup
    `cp #{todo_file} #{backup_file}`
  end

  def ed_command! command, *input_text
    backup
    text = input_text.empty? ? nil : "\n#{input_text.join(' ')}\n."
    IO.popen("ed -s #{todo_file}", 'w') {|pipe|
      script = <<END
#{command}#{text}
wq
END
      pipe.puts script
      pipe.close
    }
    exec "diff --ed  #{backup_file} #{todo_file}"
  end

  def revert
    return unless File.exist?(backup_file)
    exec <<END
mv #{todo_file} #{backup_file}.2
mv #{backup_file} #{todo_file}
mv #{backup_file}.2 #{backup_file}
END
  end

  def catn(list_file = todo_file)
    $stderr.puts
    exec <<END
cat -n #{list_file} | #{colorizer}
echo 1>&2 2>/dev/null
END
  end

  def filter(context_or_project=nil, list_file=todo_file, no_exec=false)
    s = context_or_project
    $stderr.puts
    # don't put /< before the grep arg

    grep_arg = if s && s =~ /^!/ 
      s
    elsif s
      "#{s}\\>"
    elsif s.nil?
      ".*"
    end
    grep_filter = grep_arg && " | grep -i '#{grep_arg}' " 
    script = <<END
cat -n #{list_file} #{grep_filter} | #{colorizer} #{s ? "'#{s}'" : ''}
echo 1>&2 2>/dev/null
END
    if no_exec
      script
    else
      exec(script)
    end
  end

  def filter_done_file(t)
    filter t, done_file
  end

  def list_all tag=nil
    a = filter tag, todo_file, true
    b = filter tag, done_file, true
    exec ["echo 'todo'", a, "echo 'done'", b].join("\n")
  end

  def mark_done! range
    return unless range =~ /\S/
    backup
    exec <<END
cat #{todo_file} | sed -n '#{range}p' | 
  awk '{print d " " $0}' "d=$(date +'%Y-%m-%d')" >> #{done_file}
echo "#{range}d\nwq\n" | ed -s #{todo_file} 
END
  end

  def mark_undone! range
    return unless range =~ /\S/
    backup
    exec <<END
cat #{done_file} | sed -n '#{range}p' | 
  ruby -n -e  'puts $_.split(" ", 2)[1]'  >> #{todo_file}
echo "#{range}d\nwq\n" | ed -s #{done_file} 
END
  end

  TAG_REGEX = /[@\+]\S+/
   
  def report
    report_data = get_report_data 
    # count priority items per tag
    File.readlines(todo_file).inject(report_data) {|report_data, line|
      line.scan(TAG_REGEX).each {|tag|
        report_data[tag][:priority] ||= 0
        if line =~ /!/
          report_data[tag][:priority] = report_data[tag][:priority] + 1
        end
      }; report_data
    }
    longest_tag_len = report_data.keys.reduce(0) {|max, key| [max, key.length].max} + 3
    placeholders = "%-#{longest_tag_len}s %8s %8s %8s" 
    headers = %w(tag priority todo done)
    IO.popen(colorizer, 'w') {|pipe|
      pipe.puts(placeholders % headers)
      pipe.puts placeholders.scan(/\d+/).map {|a|'-'*(a.to_i)}.join(' ')
      report_data.keys.sort_by {|k| k.downcase}.each {|k|
        pipe.puts placeholders % [k, report_data[k][:priority], report_data[k][:todo], report_data[k][:done]]
      }
    }
  end

  def get_report_data 
    [:todo, :done].
      select {|a| File.exist?(send("#{a}_file"))}.
      inject({}) {|m, list|
        file = "#{list}_file"
        File.read(send(file)).scan(TAG_REGEX).group_by {|t| t}.
          map {|k, v|
            m[k] ||= {todo:0,done:0,priority:0}
            m[k][list] = (m[k][list] || 0) + v.size
          }
        m
      }
  end

  def self.expand_tag(t)
    return unless t
    re = /^#{Regexp.escape(t)}/
    match = new.get_report_data.keys.detect {|key| key =~ re} 
    if match && match != t
      $stderr.puts "Expanding #{t} -> #{match}"
      match
    else
      t
    end
  end
end


