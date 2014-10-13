class Evaluator

  # Read JSON from file and return the string
  def self.read_json(filename)
    str = ""
    File.open(filename, "r") do |f|
      f.each_line do |line|
        str += line
      end
    end
    str
  end

  # Return an array of Alternative objects
  def self.read_alternatives(alternatives)
    arrayAlternatives = []
    alternatives.each { |alternative|
      alternativeObj = Alternative.new(alternative["text"], alternative["code"], alternative["value"])
      arrayAlternatives << alternativeObj
    }
    arrayAlternatives
  end

  # Read the exam and return an array of Question objects
  def self.read_questions(questionsJson)
    arrayQuestions = []
    questionsJson["questions"].each { |item|
      question = nil
      if item["type"] == "multichoice"
        alternatives = Evaluator.read_alternatives(item["alternatives"])
        question = Multichoice.new(item["id"], item["questionText"], alternatives)
      elsif item["type"] == "truefalse"
        question = TrueFalse.new(item["id"], item["questionText"],
                                 item["correct"], item["valueOK"],
                                 item["valueFailed"], item["feedback"])
      end
      arrayQuestions << question
    }
    arrayQuestions
  end

  # Return an array of Answer objects
  def self.read_answers(answers)
    arrayAnswers = []
    answers.each { |answer|
      answerObj = Answer.new(answer["question"], answer["value"])
      arrayAnswers << answerObj
    }
    arrayAnswers
  end

  # Read the items and return an array of Item objects
  def self.read_items(assessmentJson)
    arrayItems = []
    assessmentJson["items"].each { |item|
      answers = Evaluator.read_answers(item["answers"])
      itemObj = Item.new(item["studentId"], answers)
      arrayItems << itemObj
    }
    arrayItems
  end

  # Read the scores and return an array of Score objects
  def self.read_scores(scoresJson)
    arrayScores = []
    scoresJson["scores"].each { |item|
      scoreObj = Score.new(item["studentId"], item["value"])
      arrayScores << scoreObj
    }
    arrayScores
  end

  # Return Quiz and Assessment objects from JSON filenames
  def self.json_filename_to_obj(fileNameQuiz, fileNameAssessment)
    # Read questions JSON from file
    questionsStr = Evaluator.read_json(fileNameQuiz)
    # Read assessment JSON from file
    assessmentStr = Evaluator.read_json(fileNameAssessment)
    Evaluator.json_to_obj(questionsStr, assessmentStr)
  end

  # Return Quiz and Assessment objects from JSON strings
  def self.json_to_obj(quizStr, assessmentStr)
    # Parse question json into a hash array
    questionsJson = JSON.parse(quizStr)
    # Parse assessment json into a hash array
    assessmentJson = JSON.parse(assessmentStr)
    # New object with all the questions
    quizObj = Quiz.new(Evaluator.read_questions(questionsJson))
    # New object with all the items
    assessmentObj = Assessment.new(Evaluator.read_items(assessmentJson))
    return quizObj, assessmentObj
  end

  # Iterate over all the tests of the manifest and return a string cointaining the matching result
  def self.iterateManifest(manifestJson)
    strResult = ""
    testCount = 1
    manifestJson["tests"].each { |item|
      #Read JSONs from URIs
      quizStr = open(item["quizz"]).read
      assessmentStr = open(item["assessment"]).read
      scoresStr = open(item["scores"]).read

      quizObj, assessmentObj = Evaluator.json_to_obj(quizStr, assessmentStr)
      # Compute scores based on Quiz and Assessment
      scoresObjComputed = Evaluator.evaluate(quizObj, assessmentObj)
      # Parse scores json into a hash array
      scoresJson = JSON.parse(scoresStr)
      # New object with all the read scores
      scoresObjRead = Scores.new(Evaluator.read_scores(scoresJson))
      strResult += "Manifest test "+testCount.to_s+" matches: " + scoresObjComputed.is_equal?(scoresObjRead).to_s + "\n"
      testCount += 1
    }
    return strResult
  end

  ## EVALUATION FUCNTIONS ##

  # Compute and get the students marks based on the quiz and the assessment
  def self.evaluate(quizObj, assessmentObj)
    scoresArray = []
    assessmentObj.items.each { |item|
      score_studentId = item.studentId
      score_value = Evaluator.compute_mark(quizObj, item.answers, score_studentId)
      scoreObj = Score.new(score_studentId, score_value)
      scoresArray.push(scoreObj)
    }
    scoresObj = Scores.new(scoresArray)
    scoresObj
  end

  # Get the mark of one student
  def self.compute_mark(quizObj, studentAnswers, studentId)
    mark = 0.0
    studentAnswers.each { |item|
      question = Evaluator.search(item.question, quizObj)
      if question.class == Multichoice
        # Checking type
        if !item.value.is_a?(Fixnum)
          raise "Student (id:"+studentId.to_s+", question:"+item.question.to_s+") answer has a wrong value type (should be a number)"
        end
        mark += Evaluator.get_mark_multichoice(question.alternatives, item.value)
      elsif question.class == TrueFalse
        # Checking type
        if !item.value.is_a?(TrueClass) and !item.value.is_a?(FalseClass)
          raise "Student (id:"+studentId.to_s+", question:"+item.question.to_s+") answer has a wrong value type (should be a boolean)"
        end
        mark += Evaluator.get_mark_truefalse(question, item.value)
      end
    }
    mark
  end

  # Find the matching question from the answer code ("question")
  def self.search(answerCode, quizObj)
    elements = quizObj.questions.select { |item| item.id == answerCode}
    elements[0]
  end

  # Get the mark of Multichoice questions
  def self.get_mark_multichoice(alternatives, value)
    elements = alternatives.select{ |item| item.code == value }
    elements[0].value
  end

  # Get the mark of TrueFalse questions
  def self.get_mark_truefalse(question, value)
    if question.correct == value
      question.valueOK
    else
      question.valueFailed
    end
  end

end