class Question
  attr_accessor :id
  attr_accessor :questionText

  def initialize(id, questionText)
    @id = id
    @questionText = questionText
  end
end