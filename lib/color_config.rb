require 'yaml'
require 'color/css'

class ColorConfig
  FILES = ["colors.yml", "#{ENV['HOME']}/.todo.rb/colors.yml"]

  def initialize
    @dict = {
      'context' =>  "cyan",
      'project' => "DC143C",
      'priority' => 'FFFF00'
    }
    if (file = FILES.detect {|x| File.exist?(x)})
      @dict.merge!(YAML::load(File.read(file)))
    end
    # correct any non hex color names
    @dict.each {|k, v|
      if v !~ /[A-F0-9]{6}/
        c = Color::CSS[v]
        if c
          @dict[k] = c.html
        end
      end
    }
  end

  def raw(key)
    s = @dict[key].to_s.sub(/^#/, '').upcase
    s.length == 3 ? (s + s) : s
  end

  def rgb(key)
    @dict[key] && "RGB_" + raw(key).scan(/[A-F0-9]{2}/).join
  end

  def html(key)
    @dict[key] && "#" + raw(key).scan(/[A-F0-9]{2}/).join
  end
end
