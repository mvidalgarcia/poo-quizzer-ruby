class Item
  attr_accessor :studentId
  attr_accessor :answers

  def initialize(studentId, answers)
    @studentId = studentId
    @answers = answers
  end

end