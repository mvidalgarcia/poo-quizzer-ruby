Dir[File.dirname(__FILE__) + '/../lib/quizzer/exam/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/../lib/quizzer/assessment/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/../lib/quizzer/scores/*.rb'].each { |file| require file }
require_relative '../lib/quizzer/evaluator'
require 'json'

describe "Comparator:" do
  let (:scores) {
    %({ "scores":
      [ { "studentId": 234, "value": 0.75 } ,
        { "studentId": 245, "value": 2.0 } ,
        { "studentId": 221, "value": 0.75 }
      ]
     })
  }
  let (:scoresObj) {Scores.new(Evaluator.read_scores(JSON.parse(scores))) }

  it "A Scores object compared with itself must be equal" do
    expect(scoresObj.is_equal?(scoresObj)).to eq(true)
  end

end

describe "Evaluator:" do

  let (:questions) {
 %({ "questions":
     [ { "type": "multichoice",
         "id" : 1,
         "questionText": "Scala fue creado por...",
       "alternatives": [
         { "text": "Martin Odersky",   "code": 1, "value": 1 },
       { "text": "James Gosling",    "code": 2, "value": -0.25 },
       { "text": "Guido van Rossum", "code": 3, "value": -0.25 }
      ]
     },
    { "type" : "truefalse",
      "id" : 2,
      "questionText": "El creador de Ruby es Yukihiro Matsumoto",
      "correct": true,
      "valueOK": 1,
      "valueFailed": -0.25,
      "feedback": "Yukihiro Matsumoto es el principal desarrollador de Ruby desde 1996"
    }
   ]
  })
  }

  let (:assessment) {
    %( {"items" :
    [  {"studentId" : 234,
        "answers" :
        [{"question" : 1, "value" : 1 },
        {"question" : 2, "value" : false}
        ]
    },
        {"studentId" : 245,
        "answers" :
        [{"question" : 1, "value" : 1},
        {"question" : 2, "value" : true}
        ]
    },
        {"studentId" : 221,
        "answers" :
        [{"question" : 1, "value" : 2},
        {"question" : 2, "value" : true}
        ]
        }
    ]
    })
  }

  let (:scores) {
   %({ "scores":
      [ { "studentId": 234, "value": 0.75 } ,
        { "studentId": 245, "value": 2.0 } ,
        { "studentId": 221, "value": 0.75 }
      ]
    })
  }

  let (:quizObj) { Quiz.new(Evaluator.read_questions(JSON.parse(questions))) }
  let (:assessmentObj) {Assessment.new(Evaluator.read_items(JSON.parse(assessment))) }
  let (:scoresObjRead) {Scores.new(Evaluator.read_scores(JSON.parse(scores))) }

  it "JSON scores both computed and read must match" do
    expect(Evaluator.evaluate(quizObj, assessmentObj).is_equal?(scoresObjRead)).to eq(true)
  end

end

describe "Questions seeker:" do

  let (:questions) {
    %({ "questions":
     [ { "type": "multichoice",
         "id" : 1,
         "questionText": "Scala fue creado por...",
       "alternatives": [
         { "text": "Martin Odersky",   "code": 1, "value": 1 },
       { "text": "James Gosling",    "code": 2, "value": -0.25 },
       { "text": "Guido van Rossum", "code": 3, "value": -0.25 }
      ]
     },
    { "type" : "truefalse",
      "id" : 2,
      "questionText": "El creador de Ruby es Yukihiro Matsumoto",
      "correct": true,
      "valueOK": 1,
      "valueFailed": -0.25,
      "feedback": "Yukihiro Matsumoto es el principal desarrollador de Ruby desde 1996"
    }
   ]
  })
  }

  let (:quizObj) { Quiz.new(Evaluator.read_questions(JSON.parse(questions))) }

  it "Must search the question from the id" do
    expect(Evaluator.search(1,quizObj).questionText).to eq("Scala fue creado por...")
  end

  it "Must search the question from the id" do
    expect(Evaluator.search(2,quizObj).questionText).to eq("El creador de Ruby es Yukihiro Matsumoto")
  end
end




describe "Compute marks:" do

  let (:questions) {
    %({ "questions":
     [ { "type": "multichoice",
         "id" : 1,
         "questionText": "Scala fue creado por...",
       "alternatives": [
         { "text": "Martin Odersky",   "code": 1, "value": 1 },
       { "text": "James Gosling",    "code": 2, "value": -0.25 },
       { "text": "Guido van Rossum", "code": 3, "value": -0.25 }
      ]
     },
    { "type" : "truefalse",
      "id" : 2,
      "questionText": "El creador de Ruby es Yukihiro Matsumoto",
      "correct": true,
      "valueOK": 1,
      "valueFailed": -0.25,
      "feedback": "Yukihiro Matsumoto es el principal desarrollador de Ruby desde 1996"
    }
   ]
  })
  }

  let (:quizObj) { Quiz.new(Evaluator.read_questions(JSON.parse(questions))) }
  let (:studentAnswers) {[Answer.new(1, 2), Answer.new(2, true)]}

  it "Must compute student mark" do
    expect(Evaluator.compute_mark(quizObj, studentAnswers, 221)).to eq(0.75)
  end

end
