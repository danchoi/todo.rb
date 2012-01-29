
class ColorConfig
  def initialize
    @dict = {
      'context' =>  "ECECEC",
      'project' => "DC143C",
      '@cambridgeport' => '9400D3',
      'priority' => 'FFFF00'
    }
  end

  def rgb(key)
    @dict[key] && "RGB_" + @dict[key].upcase.scan(/[A-F0-9]{2}/).join
  end

  def html(key)
    @dict[key] && "#" + @dict[key].upcase.scan(/[A-F0-9]{2}/).join
  end
end
