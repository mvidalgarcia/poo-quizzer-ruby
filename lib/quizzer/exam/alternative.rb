class Alternative
  attr_accessor :text
  attr_accessor :code
  attr_accessor :value

  def initialize(text, code, value)
    @text = text
    @code = code
    @value = value
  end

end