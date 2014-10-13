class Score
  attr_accessor :studentId
  attr_accessor :value

  def initialize(studentId, value)
    @studentId = studentId
    @value = value
  end
end