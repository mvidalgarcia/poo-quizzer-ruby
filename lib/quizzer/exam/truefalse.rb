require_relative 'question'

class TrueFalse < Question
  attr_accessor :correct
  attr_accessor :valueOK
  attr_accessor :valueFailed
  attr_accessor :feedback

  def initialize(id, questionText, correct, valueOK, valueFailed, feedback)
    super(id, questionText)
    @correct = correct
    @valueOK = valueOK
    @valueFailed = valueFailed
    @feedback = feedback
  end
end