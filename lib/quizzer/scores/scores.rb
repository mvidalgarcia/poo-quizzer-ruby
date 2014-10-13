class Scores
  attr_accessor :scores

  def initialize(scores)
    @scores = scores
  end

  # Return a JSON string from a Scores object
  def scores_obj_to_json_str
    strJson = "{\"scores\":["
    @scores.length.times do |i|
      strJson += "{\"studentId\": " + @scores[i].studentId.to_s + ", \"value\": " + @scores[i].value.to_s + "}"
      if i != @scores.length-1 then strJson += ", " end
    end
    strJson += "]}"
    strJson
  end

  # Compare two Scores objects and return true or false
  def is_equal?(scoresObj)
    @scores.each { |score|
      elements = scoresObj.scores.select {|scoreObj| scoreObj.studentId == score.studentId}
      if !elements[0] then return false end
      if !elements[0].value == score.value then return false end
    }
    return true
  end
end