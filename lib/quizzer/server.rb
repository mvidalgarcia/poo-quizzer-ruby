class Server
  # Upload and save the Json files
  def post(params)
    emptyUploadsFolder
    # Save quiz and assessment files in the server
    pathJsonQuiz = save_json_quiz(params)
    pathJsonAssessment = save_json_assessment(params)

    # Evaluate Quiz and Answers read
    quizObj, assessmentObj = Evaluator.json_filename_to_obj(pathJsonQuiz, pathJsonAssessment)
    jsonScoreContent = Evaluator.evaluate(quizObj, assessmentObj).scores_obj_to_json_str
    # New json file with the content got
    filepath = "uploads/score_"+Time.now.strftime("%Y-%m-%d-%H%M%S")+".json"
    File.open(filepath, 'w') {|f| f.write(jsonScoreContent) }
    filepath
    #'success'
  end

  #Empty uploads/ directory
  def emptyUploadsFolder
    Dir.foreach("uploads/") {|f| fn = File.join("uploads", f); File.delete(fn) if f != '.' && f != '..'}
  end

  # Save the Quiz JSON file and return its pathname
  def save_json_quiz(params)
    unless params[:filequiz] && (tmpfileQuiz = params[:filequiz][:tempfile]) && (nameQuiz = params[:filequiz][:filename])
      return haml(:upload)
    end
    #while blk = tmpfile.read(65536)
    File.open(File.join(Dir.pwd, "uploads", nameQuiz), "wb") { |f| f.write(tmpfileQuiz.read) }
    #end
    File.join(Dir.pwd, "uploads", nameQuiz)
  end

  # Save the Assessment JSON file and return its pathname
  def save_json_assessment(params)
    unless params[:fileassessment] && (tmpfileAssessment = params[:fileassessment][:tempfile]) && (nameAssessment = params[:fileassessment][:filename])
      return haml(:upload)
    end
    #while blk = tmpfileAssessment.read(65536)
    File.open(File.join(Dir.pwd, "uploads", nameAssessment), "wb") { |f| f.write(tmpfileAssessment.read) }
    #end
    File.join(Dir.pwd, "uploads", nameAssessment)
  end
end