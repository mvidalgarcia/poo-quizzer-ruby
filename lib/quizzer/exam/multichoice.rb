require_relative 'question'

class Multichoice < Question
  attr_accessor :id
  attr_accessor :questionText
  attr_accessor :alternatives

  def initialize(id, questionText, alternatives)
    super(id, questionText)
    @alternatives = alternatives
  end
end