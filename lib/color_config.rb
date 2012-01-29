require 'yaml'

class ColorConfig
  FILES = ["colors.yml", "#{ENV['HOME']}/.todo.rb/colors.yml"]

  def initialize
    @dict = {
      'context' =>  "ECECEC",
      'project' => "DC143C",
      'priority' => 'FFFF00'
    }
    if (file = FILES.detect {|x| File.exist?(x)})
      @dict.merge!(YAML::load(File.read(file)))
    end
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
