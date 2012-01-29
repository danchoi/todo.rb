require 'yaml'

class ColorConfig
  FILE = "colors.yml"

  def initialize
    @dict = {
      'context' =>  "ECECEC",
      'project' => "DC143C",
      'priority' => 'FFFF00'
    }
    if File.exist?(FILE)
      @dict.merge!(YAML::load(File.read(FILE)))
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
